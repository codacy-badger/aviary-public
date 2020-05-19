require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  let(:collection) { create(:collection) }
  let(:sample_file) { fixture_file_upload("#{Rails.root}/spec/fixtures/import_collection_ip_list.csv", 'text/csv') }
  before do
    request[:subdomain] = collection.organization.url
    allow(controller).to receive(:current_organization).and_return(collection.organization)
    allow(controller).to receive(:current_user).and_return(collection.organization.user)
    sign_in(collection.organization.user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end
  
  describe "Index" do
    it "has a 200 status code with current organization" do
      organization = collection.organization
      puts organization
      allow(controller).to receive(:current_organization).and_return(organization)
      allow(controller).to receive(:current_user).and_return(organization.user)
      get :index
      expect(response.status).to eq(200)
    end

    it "has a 200 status code with current organization" do
      organization = collection.organization
      allow(controller).to receive(:current_organization).and_return(organization)
      allow(controller).to receive(:current_user).and_return(organization.user)
      get :index
      expect(assigns(:collections).first).to eq(collection)
    end
  end

  describe "New" do
    it "has a 200 status code" do
      get :new
      expect(response.status).to eq(200)
    end

    it "has a 200 status code with current organization" do
      get :new
      expect(assigns(:collection)).to be_a_new(Collection)
    end
  end

  describe "Create" do
    it "will create collection when params are provided" do
      post :create, params: { collection: { title: 'Test Collection', about: 'Testing', is_public: true, is_featured: true }}
      expect(assigns(:collection).title).to eq('Test Collection')
    end

    it "will not create collection when params are not provided" do
      post :create, params: { collection: { is_public: true, is_featured: true }}
      expect(assigns(:collection).title).to eq(nil)
    end
  end

  describe "edit" do
    context "when not an xhr request" do
      it "will return collection field sort" do
        collection_field_sort = collection.all_fields['Collection']
        get :edit, params: { id: collection.id }
        expect(assigns(:dynamic_fields)['Collection'].first).to eq(collection_field_sort.first)
      end

      it "will return collection resource field sort" do
        collection_resource_field = collection.all_fields['CollectionResource']
        get :edit, params: { id: collection.id }
        expect(assigns(:dynamic_fields)['CollectionResource'].first).to eq(collection_resource_field.first)
      end
      #
      it "will return collection field sort" do
        collection_resource = create(:collection_resource, title: 'testing resource', collection: collection)
        get :edit, params: { id: collection.id }
        expect(assigns(:collection_resource)).to eq(collection_resource)
      end
    end
  end

  describe "update" do
    context "when collection update" do
      it "will create collection when params are provided" do
        dynamic_attrs = collection.dynamic_attributes
        first_field = dynamic_attrs['fields'].first
        current_settings = dynamic_attrs['settings']['Collection'].rotate(2)
        updated_settings = {}
        current_settings.each do |setting|
          updated_settings[setting['field_id']] = setting
        end
        put :update, params: { id: collection.id, collection: { title: 'Test Collection1', about: 'Testing', is_public: true, is_featured: true,
          collection_field_values_attributes: [{ collection_field_id: first_field.id, value: 'hello' }] }, collection_settings: updated_settings }
        expect(assigns(:collection).title).to eq('Test Collection1')
      end
    end
  end

  describe "list_resources" do
    context "when collection list_resources" do
      it "list_resources" do
        dynamic_attrs = collection.dynamic_attributes
        first_field = dynamic_attrs['fields'].first
        current_settings = dynamic_attrs['settings']['Collection'].rotate(2)
        updated_settings = {}
        current_settings.each do |setting|
          updated_settings[setting['field_id']] = setting
        end
        put :list_resources, params: { id: collection.id, collection: { title: 'Test Collection1', about: 'Testing', is_public: true, is_featured: true,
                                                                        collection_field_values_attributes: [{ collection_field_id: first_field.id, value: 'hello' }] }, collection_settings: updated_settings }
        assigns(:collection).title.include?('title')
      end
    end
  end

  describe "update_sort_fields" do
    it "will return collection" do
      collection_resource_field = collection.dynamic_attributes['settings']['CollectionResource'].rotate(3)
      updated_settings = {}
      collection_resource_field.each_with_index do |setting, index|
        unless index != 0
          updated_settings[setting['field_id']] = { field_id: setting['field_id'], is_visible: true, is_tombstone: false}.as_json
        else
          updated_settings[setting['field_id']] = setting
        end
      end
      get :update_sort_fields, xhr: true, params: { id: collection.id, collection_resource_field: updated_settings }
      expect(JSON.parse(response.body)['status']).to eq('success')
    end
  end

  describe "Delete Destroy" do
    it "has a 302 status code" do
      delete :destroy, params: { id: collection.id }
      expect(response.status).to eq(302)
      expect(Collection.all).to be_empty
    end
  end


  describe "Show" do
    it "has a 200 status code with current organization" do
      get :show, params: { id: collection.id }
      organization = collection.organization
      allow(controller).to receive(:current_organization).and_return(organization)
      allow(controller).to receive(:current_user).and_return(organization.user)
      expect(response.status).to eq(200)
    end
  end

  describe "Bulk edit" do
    let(:collection_with_resource) { create(:collection_with_multiple_files) }
    it "Bulk Resource List" do
      request.accept = "application/json"
      get :bulk_resource_list, params: { collection_resource_id: collection_with_resource.collection_resources.first.id, ids: collection_with_resource.collection_resources.pluck(:id), status: '1', bulk: 'add' }
      expect(response.status).to eq(200).or eq(202)
    end

    it "Bulk Edit Operation" do
      request.accept = "application/json"
      session[:resource_list_bulk_edit] = collection_with_resource.collection_resources.pluck(:id)
      post :bulk_edit_operation, params: { bulk_edit: { type_of_bulk_operation: 'change_media_file_status', status: 'access_private' } }
      expect(response.status).to eq(200).or eq(202)
    end

    it "Bulk Edit Operation Collection change" do
      request.accept = "application/json"
      collection_resource = create(:collection_resource, collection: collection, is_featured: false)
      session[:resource_list_bulk_edit] = collection_with_resource.collection_resources.pluck(:id)
      post :bulk_edit_operation, params: { bulk_edit_status: 'access_restricted', bulk_edit_type_of_bulk_operation: 'assign_to_collection', bulk_edit_featured: 'Yes', bulk_edit_collections: collection.id, ids: [collection_resource.id] }
      expect(response.status).to eq(200).or eq(202)
    end

    it "Fetch Bulk Edit Resource List" do
      session[:resource_list_bulk_edit] = collection_with_resource.collection_resources.pluck(:id)
      get :fetch_bulk_edit_resource_list, params: {}
      expect(response.status).to eq(200).or eq(202)
    end

    it "Update Progress" do
      request.accept = "application/json"
      get :update_progress, params: { bulk_edit_type_of_bulk_operation: 'change_status', ids: collection_with_resource.collection_resources.pluck(:id) }
      expect(response.status).to eq(200).or eq(202)
    end
  end


  describe "Export CSV" do
    it "should return csv" do
      get :export, params: { export_type: 'collection' }
      response.header['Content-Type'].should eql('csv')
      response.header['Content-Disposition'].include?("collection")
    end

    it "should return collection csv" do
      get :export, params: { export_type: 'collection' }
      response.header['Content-Disposition'].include?("collection")
    end

    it "should return resource csv" do
      get :export, params: { export_type: 'resources' }
      response.header['Content-Disposition'].include?("collection_resources")
    end
  end
end

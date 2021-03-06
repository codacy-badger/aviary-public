# controllers/transcript_controllers.rb
#
# TranscriptsController
# The module is written to store the index and transcript for the collection resource file
# Currently supports OHMS XML and WebVtt format
# Nokogiri, webvtt-ruby gem is needed to run this module successfully
# dry-transaction gem is needed for adding transcript steps to this process
#
# Author::    Nouman Tayyab  (mailto:nouman@weareavp.com)
class TranscriptsController < ApplicationController
  before_action :authenticate_user!, except: :export

  def create
    if params[:file_transcript_id]
      file_transcript = FileTranscript.find(params[:file_transcript_id])
      success = file_transcript.update(file_transcript_params)
    else
      file_transcript = FileTranscript.new(file_transcript_params)
      file_transcript.user = current_user
      resource_file = CollectionResourceFile.find(params[:resource_file_id])
      file_transcript.collection_resource_file = resource_file
      file_transcript.sort_order = resource_file.file_transcripts.length + 1
      success = file_transcript.save
    end
    respond_to do |format|
      if success
        file_transcript.file_transcript_points.destroy_all if params[:file_transcript_id] && file_transcript_params[:associated_file].present?
        if file_transcript_params[:associated_file].present?
          remove_title = params[:file_transcript][:remove_title] == '1' ? '1' : ''
          result = Aviary::IndexTranscriptManager::TranscriptManager.new.process(file_transcript, remove_title)
          if result.failure?
            file_transcript.destroy
            format.json { render json: [errors: { associated_file: ['Failed to process the file.'] }] }
          else
            format.json { render json: [errors: []] }
          end
        else
          format.json { render json: [errors: []] }
        end
      else
        format.json { render json: [errors: file_transcript.errors] }
      end
    end
  end

  def sort
    unless params[:sort_list].nil?
      params[:cc] ||= []
      params[:sort_list].each_with_index do |id, index|
        is_caption = params[:cc].include? id
        FileTranscript.where(id: id).update_all(sort_order: index + 1, is_caption: is_caption)
      end
    end
    respond_to do |format|
      format.json { render json: [errors: []] }
    end
  end

  def destroy
    file_transcript = FileTranscript.find(params[:id])
    file_transcript.destroy
    flash[:notice] = t('transcript_deleted')
    redirect_back(fallback_location: root_path)
  end

  def export
    file_transcript = FileTranscript.find_by_id(params[:id])
    if file_transcript.present? && %w[webvtt txt json].include?(params[:type])
      collection_resource = file_transcript.collection_resource_file.collection_resource
      if file_transcript.is_public || collection_resource.can_view || collection_resource.can_edit || (can? :edit, collection_resource.collection.organization)
        export_text = Aviary::ExportTranscript.new.export(file_transcript, params[:type])
        send_data(export_text, filename: "export_transcript_#{Time.now.to_i}.#{params[:type]}")
      else
        flash[:notice] = 'You don\'t have the access to download the transcript'
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:notice] = 'Unable to export the transcript.'
      redirect_back(fallback_location: root_path)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def file_transcript_params
    params.require(:file_transcript).permit(:title, :is_caption, :associated_file, :is_public, :language, :is_edit, :draftjs)
  end
end

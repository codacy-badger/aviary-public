# Creates default super_admin user and default roles '
puts '============================ Roles ============================'
puts '==============================================================='

roles = %w(organization_owner organization_admin organization_user)
roles.each do |r|
  Role.where(system_name: r, name: r.gsub("_", " ").titleize).first_or_create
end
puts '============================  Admin ============================'
puts '================================================================'
user = Admin.where(email: 'admin@demo.com').first_or_initialize
user.first_name = 'AVIARY'
user.last_name = 'ADMIN'
user.password = 'demoadmin'
user.password_confirmation = 'demoadmin'
user.username = 'admin'
user.agreement = 1
user.save(validate: false)

puts '======================== Default Fields ========================'
puts '================================================================'
agents = ['Abridger',
          'Actor',
          'Adapter',
          'Addressee',
          'Analyst',
          'Animator',
          'Annotator',
          'Appellant',
          'Appellee',
          'Applicant',
          'Architect',
          'Arranger',
          'Art copyist',
          'Art director',
          'Artist',
          'Artistic director',
          'Assignee',
          'Associated name',
          'Attributed name',
          'Auctioneer',
          'Author',
          'Author in quotations or text abstracts',
          'Author of afterword, colophon, etc.',
          'Author of dialog',
          'Author of introduction, etc.',
          'Autographer',
          'Bibliographic antecedent',
          'Binder',
          'Binding designer',
          'Blurb writer',
          'Book designer',
          'Book producer',
          'Bookjacket designer',
          'Bookplate designer',
          'Bookseller',
          'Braille embosser',
          'Broadcaster',
          'Calligrapher',
          'Cartographer',
          'Caster',
          'Censor',
          'Choreographer',
          'Cinematographer',
          'Client',
          'Collection registrar',
          'Collector',
          'Collotyper',
          'Colorist',
          'Commentator',
          'Commentator for written text',
          'Compiler',
          'Complainant',
          'Complainant-appellant',
          'Complainant-appellee',
          'Composer',
          'Compositor',
          'Conceptor',
          'Conductor',
          'Conservator',
          'Consultant',
          'Consultant to a project',
          'Contestant',
          'Contestant-appellant',
          'Contestant-appellee',
          'Contestee',
          'Contestee-appellant',
          'Contestee-appellee',
          'Contractor',
          'Contributor',
          'Copyright claimant',
          'Copyright holder',
          'Corrector',
          'Correspondent',
          'Costume designer',
          'Court governed',
          'Court reporter',
          'Cover designer',
          'Creator',
          'Curator',
          'Dancer',
          'Data contributor',
          'Data manager',
          'Dedicatee',
          'Dedicator',
          'Defendant',
          'Defendant-appellant',
          'Defendant-appellee',
          'Degree granting institution',
          'Degree supervisor',
          'Delineator',
          'Depicted',
          'Depositor',
          'Designer',
          'Director',
          'Dissertant',
          'Distribution place',
          'Distributor',
          'Donor',
          'Draftsman',
          'Dubious author',
          'Editor',
          'Editor of compilation',
          'Editor of moving image work',
          'Electrician',
          'Electrotyper',
          'Enacting jurisdiction',
          'Engineer',
          'Engraver',
          'Etcher',
          'Event place',
          'Expert',
          'Facsimilist',
          'Field director',
          'Film director',
          'Film distributor',
          'Film editor',
          'Film producer',
          'Filmmaker',
          'First party',
          'Forger',
          'Former owner',
          'Funder',
          'Geographic information specialist',
          'Honoree',
          'Host',
          'Host institution',
          'Illuminator',
          'Illustrator',
          'Inscriber',
          'Instrumentalist',
          'Interviewee',
          'Interviewer',
          'Inventor',
          'Issuing body',
          'Judge',
          'Jurisdiction governed',
          'Laboratory',
          'Laboratory director',
          'Landscape architect',
          'Lead',
          'Lender',
          'Libelant',
          'Libelant-appellant',
          'Libelant-appellee',
          'Libelee',
          'Libelee-appellant',
          'Libelee-appellee',
          'Librettist',
          'Licensee',
          'Licensor',
          'Lighting designer',
          'Lithographer',
          'Lyricist',
          'Manufacture place',
          'Manufacturer',
          'Marbler',
          'Markup editor',
          'Medium',
          'Metadata contact',
          'Metal-engraver',
          'Minute taker',
          'Moderator',
          'Monitor',
          'Music copyist',
          'Musical director',
          'Musician',
          'Narrator',
          'Onscreen presenter',
          'Opponent',
          'Organizer',
          'Originator',
          'Other',
          'Owner',
          'Panelist',
          'Papermaker',
          'Patent applicant',
          'Patent holder',
          'Patron',
          'Performer',
          'Permitting agency',
          'Photographer',
          'Plaintiff',
          'Plaintiff-appellant',
          'Plaintiff-appellee',
          'Platemaker',
          'Praeses',
          'Presenter',
          'Printer',
          'Printer of plates',
          'Printmaker',
          'Process contact',
          'Producer',
          'Production company',
          'Production designer',
          'Production manager',
          'Production personnel',
          'Production place',
          'Programmer',
          'Project director',
          'Proofreader',
          'Provider',
          'Publication place',
          'Publisher',
          'Publishing director',
          'Puppeteer',
          'Radio director',
          'Radio producer',
          'Recording engineer',
          'Recordist',
          'Redaktor',
          'Renderer',
          'Reporter',
          'Repository',
          'Research team head',
          'Research team member',
          'Researcher',
          'Respondent',
          'Respondent-appellant',
          'Respondent-appellee',
          'Responsible party',
          'Restager',
          'Restorationist',
          'Reviewer',
          'Rubricator',
          'Scenarist',
          'Scientific advisor',
          'Screenwriter',
          'Scribe',
          'Sculptor',
          'Second party',
          'Secretary',
          'Seller',
          'Set designer',
          'Setting',
          'Signer',
          'Singer',
          'Sound designer',
          'Speaker',
          'Sponsor',
          'Stage director',
          'Stage manager',
          'Standards body',
          'Stereotyper',
          'Storyteller',
          'Supporting host',
          'Surveyor',
          'Teacher',
          'Technical director',
          'Television director',
          'Television producer',
          'Thesis advisor',
          'Transcriber',
          'Translator',
          'Type designer',
          'Typographer',
          'University place',
          'Videographer',
          'Voice actor',
          'Witness',
          'Wood engraver',
          'Woodcutter',
          'Writer of accompanying material',
          'Writer of added commentary',
          'Writer of added lyrics',
          'Writer of added text',
          'Writer of introduction',
          'Writer of preface',
          'Writer of supplementary textual content']
collection_field_manager = [
  {
    label: 'Identifier',
    system_name: 'identifier',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Creator',
    system_name: 'creator',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Link',
    system_name: 'link',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 6,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Date Span',
    system_name: 'date_span',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Extent',
    system_name: 'extent',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Language',
    system_name: 'language',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 1,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Conditions Governing Access',
    system_name: 'conditions_governing_access',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 6,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'Collection',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Title',
    system_name: 'title',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Preferred Citation',
    system_name: 'preferred_citation',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 6,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Source Metadata URI',
    system_name: 'source_metadata_uri',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Duration',
    system_name: 'duration',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Publisher',
    system_name: 'publisher',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Rights Statement',
    system_name: 'rights_statement',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 6,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Source',
    system_name: 'source',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Agent',
    system_name: 'agent',
    is_vocabulary: 1,
    vocabulary: agents.to_json,
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Date',
    system_name: 'date',
    is_vocabulary: 1,
    vocabulary: ['issued', 'created', 'captured', 'valid', 'modified', 'other'].to_json,
    column_type: 3,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Coverage',
    system_name: 'coverage',
    is_vocabulary: 1,
    vocabulary: ['spatial', 'temporal'].to_json,
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Language',
    system_name: 'language',
    is_vocabulary: 1,
    vocabulary: ['primary', 'secondary', 'tertiary', 'other'].to_json,
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Description',
    system_name: 'description',
    is_vocabulary: 1,
    vocabulary: ['general', 'citation', 'summary', 'scope content', 'supplement', 'other', 'abstract'].to_json,
    column_type: 6,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Format',
    system_name: 'format',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Identifier',
    system_name: 'identifier',
    is_vocabulary: 1,
    vocabulary: ['doi (Digital Objects Identifier)', 'hdl (Handle)', 'isbn (International Standard Book Number)', 'ismn (International Standard Music Number)', 'isrc (International Standard Recording Code)', 'issn (International Standard Serials Number)', 'issue number', 'istc (International Standard Text Code)', 'lccn (Library of Congress Control Number)', 'local', 'matrix number', 'music plate', 'music publisher', 'sici (Serial Item and Contribution Identifier)', 'stock number', 'upc (Universal Product Code)', 'uri (Uniform Resource Identifier)', 'videorecording identifier', 'other'].to_json,
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Relation',
    system_name: 'relation',
    is_vocabulary: 1,
    vocabulary: ['conforms to', 'has format', 'has part', 'has version', 'is format of', 'is part of', 'is referenced by', 'is replaced by', 'is required by', 'is version of', 'other'].to_json,
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Subject',
    system_name: 'subject',
    is_vocabulary: 1,
    vocabulary: ['personal name', 'corporate name', 'meeting name', 'named event', 'chronological term', 'topical term', 'geographic term', 'uncontrolled', 'genre/form', 'other'].to_json,
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Keyword',
    system_name: 'keyword',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  },
  {
    label: 'Type',
    system_name: 'type',
    is_vocabulary: 0,
    vocabulary: '',
    column_type: 4,
    dropdown_options: '',
    default: 1,
    help_text: '',
    source_type: 'CollectionResource',
    is_required: 0,
    is_repeatable: 1,
    is_public: 1,
    is_custom: 0
  }

]
collection_field_manager.each do |single_field|
  field = CustomFields::Field.where(system_name: single_field[:system_name], source_type: single_field[:source_type]).first_or_initialize
  field.update(single_field)
end

puts '============================ Plans ============================='
puts '================================================================'
plans = [
  { name: 'Starter', stripe_id: 'aviary-starter-monthly', amount: 9.95, frequency: 1, max_resources: 100 },
  { name: 'Starter', stripe_id: 'aviary-starter-yearly', amount: 95.52, frequency: 2, max_resources: 100 },
  { name: 'Pro', stripe_id: 'aviary-pro-monthly', amount: 99.95, frequency: 1, max_resources: 1000 },
  { name: 'Pro', stripe_id: 'aviary-pro-yearly', amount: 959.52, frequency: 2, max_resources: 1000 },
  { name: 'Business', stripe_id: 'aviary-business-monthly', amount: 399.95, frequency: 1, max_resources: 5000 },
  { name: 'Business', stripe_id: 'aviary-business-yearly', amount: 3839.52, frequency: 2, max_resources: 5000 },
  { name: 'Premium', stripe_id: 'aviary-premium-monthly', amount: 999.95, frequency: 1, max_resources: 25000 },
  { name: 'Premium', stripe_id: 'aviary-premium-yearly', amount: 9599.52, frequency: 2, max_resources: 25000 },
  { name: 'Premium Plus', stripe_id: 'aviary-premium-plus-monthly', amount: 1499.95, frequency: 1, max_resources: 75000 },
  { name: 'Premium Plus', stripe_id: 'aviary-premium-plus-yearly', amount: 14399.52, frequency: 2, max_resources: 75000 },
  { name: 'Premium Max', stripe_id: 'aviary-premium-max-monthly', amount: 1999.95, frequency: 1, max_resources: 150000 },
  { name: 'Premium Max', stripe_id: 'aviary-premium-max-yearly', amount: 19199.52, frequency: 2, max_resources: 150000 },
  { name: 'Enterprise', stripe_id: '', amount: 0, frequency: 3, max_resources: 9999999 },
  { name: 'Pay-as-you-go', stripe_id: 'aviary-pay-as-you-go', amount: 0, frequency: 1, max_resources: 9999999 }
]

plans.each do |plan|
  if Plan.find_by_name_and_frequency(plan[:name], plan[:frequency]).nil?
    Plan.create(plan)
  end
end

user = User.where(email: 'user@demo.com').first_or_initialize
user.first_name = 'AVIARY'
user.last_name = 'User'
user.password = 'demouser'
user.password_confirmation = 'demouser'
user.username = 'demouser'
user.agreement = 1
user.status = true
user.save(validate: false)
user.confirm

organization = Organization.where(url: 'public').first_or_initialize
organization.user = user
organization.name = 'Public'
organization.storage_type = :free_storage
organization.bucket_name = 'aviary-p_public'
organization.save(validate: false)

org_user = user.organization_users.where(organization_id: organization.id, role_id: Role.role_organization_owner.id).first_or_initialize
org_user.status = true
org_user.save

plan = Plan.find_by_name_and_frequency('Premium Max', Plan::Frequency::YEARLY)
end_time = Time.now + 1.year


subscription = Subscription.where(plan_id: plan.id, organization_id: organization.id).first_or_initialize

subscription.plan = plan
subscription.organization = organization
subscription.start_date = Time.now
subscription.renewal_date = end_time
subscription.current_price = 0.0
subscription.status = :active
subscription.save(validate: false)
binding.pry

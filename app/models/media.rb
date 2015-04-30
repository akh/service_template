class Media
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in :collection => :medias

  field :name, type: String
  field :introduction, type: String
  field :account, type: String

  validates :name, presence: true
  validates :introduction, presence: true
  validates :account, presence: true
  validates_uniqueness_of :account, case_sensitive: false

  index({account: 1}, {name: "account_index", background: true, unique: true})

  def as_json(options={})
    result = super
    result['id'] = self.id.to_s
    result.delete('_id')
    result
  end
end


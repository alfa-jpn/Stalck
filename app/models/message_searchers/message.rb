module MessageSearchers
  class Message
    include Concerns::Models::SlackAdapter

    column :type
    column :user
    column :username
    column :text
    column :attachments
    column :ts
    column :team
    column :channel
    column :permalink
    column :permalink_2
    column :next
    column :next_2
    column :previous
    column :previous_2
  end
end

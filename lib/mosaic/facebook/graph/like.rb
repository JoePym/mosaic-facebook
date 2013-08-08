module Mosaic
  module Facebook
    module Graph
      class Like < Mosaic::Facebook::Graph::GraphObject
        attr_accessor :name, :category, :id, :created_time

        class << self
          #TODO: handle paging
          def all(facebook_user, options = {})
            @all = find("/#{facebook_user}/likes", options)
          end

          def find_by_id(id, page_id, options = {})
            find("/#{id}/likes/#{page_id}", options)
          end
        end
      end
    end
  end
end

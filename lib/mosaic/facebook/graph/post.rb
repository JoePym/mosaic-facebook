module Mosaic
  module Facebook
    module Graph
      class Post < Mosaic::Facebook::Graph::GraphObject
        attr_accessor :id, :created_time, :to, :message, :type, :link, :picture, :updated_time, :source, :object_id

        def comments
          if @comments.is_a?(Hash)
            @comments = AssociationProxy.new(Mosaic::Facebook::Graph::Comment, "/#{id}/comments", @comments['data'])
          else
            @comments ||= AssociationProxy.new(Mosaic::Facebook::Graph::Comment, "/#{id}/comments")
          end
        end

        def from
          if @from.is_a?(Hash)
            @from = AssociationProxy.new(Mosaic::Facebook::Graph::User, "/#{@from['id']}")
          else
            @from
          end
        end

        %w(photo video).each do |post_type|
          define_method post_type  do
            if @object_id && @type == post_type
              instance_variable_set "@#{post_type}", (AssociationProxy.new(Mosaic::Facebook::Graph.const_get(post_type.capitalize), "/#{@object_id}"))
            end
          end
        end
      end
    end
  end
end

module Mosaic
  module Facebook
    module Graph
      class Photo < Mosaic::Facebook::Graph::GraphObject
        attr_accessor :id, :from, :source
      end
    end
  end
end

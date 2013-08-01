module Mosaic
  module Facebook
    module Graph
      class Video < Mosaic::Facebook::Graph::GraphObject
        attr_accessor :id, :from, :source
      end
    end
  end
end

require File.expand_path('../../spec_helper.rb', __FILE__)

describe Mosaic::Facebook::Graph::Post, :vcr do

  context "when searching for a post" do
    it "should return a list of posts" do
      posts = Mosaic::Facebook::Graph::Post.search("mosaic", :access_token => RSpec.configuration.access_token)
      expect(posts).to_not be_empty
      expect(posts.first).to be_an_instance_of(Mosaic::Facebook::Graph::Post)
    end
  end

  context "given a page with posts" do
    before(:all) do
      @page = Mosaic::Facebook::Graph::Page.new(:id => RSpec.configuration.page_id)
      # FIXME: limit=10 work-around for facebook bug as per:
      #        https://developers.facebook.com/bugs/525301577527928?browse=search_516709daab5da1453067889
      VCR.use_cassette("Mosaic_Facebook_Graph_Post/given_a_page_with_posts/should_get_ten_comments") do
        @posts = @page.feed.all(:access_token => RSpec.configuration.access_token, :limit => 10)
      end
    end

    it "should retrieve the user who posted it" do
      post = @posts.first
      expect(post.from.all).to be_an_instance_of Mosaic::Facebook::Graph::User
    end

    # FIXME: requires a comment to actually exist in the retrieved posts...
    #        maybe find a comment through another means first, and follow it to the post?
    context "and a post with comments" do
      before(:all) do
        VCR.use_cassette("Mosaic_Facebook_Graph_Post/given_a_page_with_posts/and_a_post_with_comments/should_get_post") do
          @post = @posts.find { |post| post.comments.all.any? }
        end
      end

      it "should retrieve the post's comments" do
        comments = @post.comments.all
        expect(comments).to be_an_instance_of Array
        expect(comments.first).to be_an_instance_of Mosaic::Facebook::Graph::Comment
      end
    end

    context "and a post with a photo" do
      it 'should create a post\'s photo' do
        VCR.use_cassette("Mosaic_Facebook_Graph_Post/given_a_page_with_posts/and_a_post_with_a_photo") do
          page = Mosaic::Facebook::Graph::Page.new(:id => RSpec.configuration.page_id)
          posts = page.feed.all(:access_token => RSpec.configuration.access_token)
          post = posts.find { |post| post.object_id && post.type == 'photo' }
          photo = post.photo.all(:access_token => RSpec.configuration.access_token)
          expect(photo).to be_an_instance_of Mosaic::Facebook::Graph::Photo
        end
      end
    end

    context "and a post with a video" do
      it 'should create a post\'s video' do
        VCR.use_cassette("Mosaic_Facebook_Graph_Post/given_a_page_with_posts/and_a_post_with_a_video") do
          page = Mosaic::Facebook::Graph::Page.new(:id => RSpec.configuration.page_id)
          posts = page.feed.all(:access_token => RSpec.configuration.access_token)
          post = posts.find { |post| post.object_id && post.type == 'video' }
          photo = post.video.all(:access_token => RSpec.configuration.access_token)
          expect(photo).to be_an_instance_of Mosaic::Facebook::Graph::Video
        end
      end
    end
  end
end

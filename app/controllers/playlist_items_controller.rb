# PlaylistItemsController
class PlaylistItemsController < ApplicationController
  include PlaylistHelper

  before_action :set_config
  before_action :set_playlist
  before_action :set_playlist_resource
  before_action :authenticate_user!
  before_action :set_playlist_item, only: %I[set_start_end_time]

  def set_start_end_time
    @playlist_item.update(start_time: params[:start_time], end_time: params[:end_time])
  end
end

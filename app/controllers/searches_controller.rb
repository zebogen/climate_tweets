$LOAD_PATH << '.'

require 'twitterpull'

class SearchesController < ApplicationController
  
  def new
    @search = Search.new
  end
  
  def create
    @search = Search.new(search_params)
    @search.tweet_block = Search.pull_tweets(search_params)
    logger.debug "Search object attributes: #{@search.attributes.inspect}"
    if @search.save
      redirect_to @search
    else
      render 'new'
    end
  end
  
  def update
    @search = Search.find(params[:id])
    
    if @search.update(search_params)
      redirect_to @search
    else
      render 'edit'
    end
  end
  
  def destroy
    @search = Search.find(params[:id])
    @search.destroy
    
    redirect_to search_path
  end
  
  def show
    @search = Search.find(params[:id])
  end
  
  def index
    @search = Search.all
  end
  
  def edit
    @search = Search.find(params[:id])
  end
  
  private
    def search_params
      params.require(:search).permit(:query, :count)
    end
  
end

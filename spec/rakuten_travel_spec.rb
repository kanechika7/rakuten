# -*- coding: utf-8 -*-
require 'rakuten'
require 'date'
require 'pp'

# see http://webservice.rakuten.co.jp/document/index.html

describe Rakuten::TravelClient do

  before(:all) do
    @developer_id = '0c40edce3a5222e2961780df16d0c0f6'
    @affiliate_id = '0d41c043.e0cdd459.0d41c044.5eaf1555'
    @client = Rakuten::TravelClient.new(@developer_id, @affiliate_id)
  end

  #
  # 楽天トラベル系API
  # 
  
  it "楽天トラベル施設検索APIの呼び出しが可能であること" do
    result = @client.simple_hotel_search('2009-10-20', {:largeClassCode => 'japan', :middleClassCode => 'akita', :smallClassCode => 'tazawa'})
    (result['pagingInfo'][0]['recordCount'] > 0).should be_true
    result['hotel'].should_not be_empty

    result = @client.simple_hotel_search('2009-10-20', {:latitude => 128440.51, :longitude => 503172.21, :searchRadius => 1})
    (result['pagingInfo'][0]['recordCount'] > 0).should be_true
    result['hotel'].should_not be_empty

    result = @client.simple_hotel_search('2009-10-20', {:hotelNo => '2763,4624'})
    (result['pagingInfo'][0]['recordCount'] > 0).should be_true
    result['hotel'].should_not be_empty
  end

  it "楽天トラベル施設情報APIの呼び出しが可能であること" do
    result = @client.hotel_detail_search('2009-09-09', {:hotelNo => '2763'})
    result['hotel'][0]['hotelRatingInfo'].should_not be_nil
  end

  it "楽天トラベル空室検索APIの呼び出しが可能であること" do
    result = @client.vacant_hotel_search('2009-10-20', {:largeClassCode => 'japan', :middleClassCode => 'akita', :smallClassCode => 'tazawa', :checkinDate => (Date.today + 1).to_s, :checkoutDate => (Date.today + 3).to_s, :adultNum => 2})
    result['hotel'].should_not be_empty
    result['pagingInfo']['recordCount'].should_not be_nil

    result = @client.vacant_hotel_search('2009-10-20', {:latitude => 128440.51, :longitude => 503172.21, :searchRadius => 1, :checkinDate => (Date.today + 1).to_s, :checkoutDate => (Date.today + 3).to_s, :adultNum => 2})
    result['hotel'].should_not be_empty
    result['pagingInfo']['recordCount'].should_not be_nil

    result = @client.vacant_hotel_search('2009-10-20', {:hotelNo => '2763,4624', :checkinDate => (Date.today + 1).to_s, :checkoutDate => (Date.today + 3).to_s, :maxCharge => 8500})
    result['hotel'].should_not be_empty
    result['pagingInfo']['recordCount'].should_not be_nil
  end
  
  it "楽天トラベル地区コードAPIの呼び出しが可能であること" do
    result = @client.get_area_class('2009-03-26')
    result['largeClass']['middleClass'].should_not be_empty
  end

  it "楽天トラベルキーワード検索APIの呼び出しが可能であること" do
    result = @client.keyword_hotel_search('2009-10-20', {:keyword => '品川シーサイド'})
    result['hotel'].should_not be_empty
    result['pagingInfo'][0]['recordCount'].should_not be_nil
  end

  it "楽天トラベルホテルチェーンAPIの呼び出しが可能であること" do
    result = @client.get_hotel_chain_list('2009-05-12')
    result['hotelChainList'].should_not be_empty
  end

  it "楽天トラベルランキングAPIの呼び出しが可能であること" do
    result = @client.hotel_ranking('2009-06-25', {:genre => 'all'})
    result['ranking'][0]['hotelRankInfo'].should_not be_empty
    result['ranking'][0]['lastBuildDate'].should_not be_nil

    result = @client.hotel_ranking('2009-06-25', {:genre => 'onsen'})
    result['ranking'][0]['hotelRankInfo'].should_not be_empty
    result['ranking'][0]['lastBuildDate'].should_not be_nil

    result = @client.hotel_ranking('2009-06-25', {:genre => 'all,onsen'})
    result['ranking'][0]['hotelRankInfo'].should_not be_empty
    result['ranking'][0]['lastBuildDate'].should_not be_nil
  end
end

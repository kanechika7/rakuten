# -*- coding: utf-8 -*-
require 'rakuten'
require 'date'
require 'pp'
require File.dirname(__FILE__) + '/ids.rb'

# see http://webservice.rakuten.co.jp/document/index.html

# テストを実行するには、ids.rb.sample のデベロッパーIDとアフィリエイトIDを書き換え、
# ids.rb という名前で保存してください.
describe Rakuten::Client do

  before(:all) do
    @developer_id = DEVELOPER_ID
    @affiliate_id = AFFILIATE_ID
    @client = Rakuten::Client.new(@developer_id, @affiliate_id)
  end

  it "API URLを正しく構築できること" do
    url = @client.request_url('ItemRanking', '2010-08-05', {})
    url.should == "http://api.rakuten.co.jp/rws/3.0/json?developerId=#{@developer_id}&operation=ItemRanking&version=2010-08-05&affiliateId=#{@affiliate_id}"
  end

  it "developerIdが無効であれば、例外が発生すること" do
    client = Rakuten::Client.new('invalid_developer_id')
    lambda{client.item_ranking('2010-08-15')}.should raise_error(Rakuten::ApiError)
  end

  it "versionが不正であれば、例外が発生すること" do
    lambda{@client.item_ranking('2010-08-01')}.should raise_error(Rakuten::ApiError)
  end

  #
  # 楽天市場系API
  #

  it "楽天商品検索APIを呼び出し可能であること" do
    result = @client.item_search('2010-09-15', {:keyword => '福袋', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_nil
  end

  it "モバイル用の呼び出しが可能であること" do
    result = @client.item_search('2010-09-15', {:keyword => '福袋', :carrier => 1})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_nil
  end

  it "楽天ジャンル検索APIの呼び出しが可能であること(ルートレベル)" do
    result = @client.genre_search('2007-04-11', {:genreId => 0})
    result['child'].should_not be_empty
    result['child'][0]['genreLevel'].should == 1
    result['child'][0]['genreName'].should_not be_nil
    result['child'][0]['genreId'].should_not be_nil
  end

  it "楽天ジャンル検索APIの呼び出しが可能であること(食品ジャンル)" do
    result = @client.genre_search('2007-04-11', {:genreId => 100227})
    result['child'].should_not be_empty
    result['child'][0]['genreLevel'].should == 2
    result['child'][0]['genreName'].should_not be_nil
    result['child'][0]['genreId'].should_not be_nil
  end

  it "楽天商品コード検索APIの呼び出しが可能であること" do
    sample = @client.item_search('2010-09-15', {:keyword => '福袋', :hits => 1})
    item_code = sample['Items']['Item'][0]['itemCode']
    # 楽天商品コード検索API呼び出し.
    result = @client.item_code_search('2010-08-05', {:itemCode => item_code})
    result['Items']['Item'].should_not be_empty
  end

  it "楽天カタログ検索APIの呼び出しが可能であること" do
    result = @client.catalog_search('2009-04-15', {:keyword => '液晶テレビ', :sort => '-reviewCount'})
    (result['count'] > 0).should be_true
    result['Catalogs']['Catalog'].should_not be_empty
  end

  it "楽天商品ランキングAPIの呼び出しが可能であること" do
    result = @client.item_ranking('2010-08-05')
    result['title'].should_not be_nil
    result['lastBuildDate'].should_not be_nil
    result['Items']['Item'].should_not be_empty
  end
  
  it "楽天プロダクト製品検索APIの呼び出しができること" do
    result = @client.product_search('2010-11-18', {:keyword => 'ノートパソコン', :genreId => 100040})
    result['Items']['Item'].should_not be_empty
  end

  it "楽天プロダクト製品詳細APIの呼び出しが可能であること" do
    sample = @client.product_search('2010-11-18', {:keyword => 'ノートパソコン', :genreId => 100040, :hits => 1})
    product_id = sample['Items']['Item'][0]['productId']
    # 楽天プロダクト製品詳細API呼び出し.
    result = @client.product_detail('2010-11-18', {:productId => product_id, :detailFlag => 1})
    result['Item'].should_not be_empty
  end

  it "楽天プロダクトジャンル情報APIの呼び出しが可能であること" do
    result = @client.product_genre_info('2010-11-18', {:genreId => 500740, :makerHits => 10, :satisfiedHits => 5, :satisfiedPage => 3})
    result['NewProductInformation'].should be_nil
    result['SatisfiedInformation']['satisfier'].should_not be_empty
    result['SellerInformation'].should be_nil
    result['GenreInformation'].should_not be_empty
    result['MakerInformation']['maker'].should_not be_empty
  end

  it "楽天プロダクトメーカー情報APIの呼び出しが可能であること" do
    result = @client.product_maker_info('2010-11-18', {:makerCode => 104901780})
    result['makerName'].should_not be_nil
  end

  it "楽天プロダクト価格比較情報APIの呼び出しが可能であること" do
    sample = @client.product_search('2010-11-18', {:keyword => 'ノートパソコン', :genreId => 100040, :hits => 1})
    product_id = sample['Items']['Item'][0]['productId']
    # 楽天プロダクトか各比較情報API呼び出し.
    result = @client.product_price_info('2010-11-18', {:productId => product_id, :availability => 1, :creditCardFlag => 1})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  #
  # 楽天ブックス系API
  # 
  
  it "楽天ブックス総合検索APIの呼び出しが可能であること" do
    result = @client.books_total_search('2010-03-18', {:keyword => 'ガンダム', :NGKeyword => '予約', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックス書籍検索APIの呼び出しが可能であること" do
    result = @client.books_book_search('2010-03-18', {:title => '太陽', :booksGenreId => '001004008', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックスCD検索APIの呼び出しが可能であること" do
    result = @client.books_CD_search('2010-03-18', {:artistName => 'サザンオールスターズ', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックスDVD検索APIの呼び出しが可能であること" do
    result = @client.books_DVD_search('2010-03-18', {:title => 'ガンダム', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックス洋書検索APIの呼び出しが可能であること" do
    result = @client.books_foreign_book_search('2010-03-18', {:title => 'HarryPotter', :booksGenreId => '005407', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックス雑誌検索APIの呼び出しが可能であること" do
    result = @client.books_magazine_search('2010-03-18', {:title => '週刊 経済', :booksGenreId => '007604001', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックスゲーム検索APIの呼び出しが可能であること" do
    result = @client.books_game_search('2010-03-18', {:title => 'マリオ', :hardware => 'Wii', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックスソフトウェア検索APIの呼び出しが可能であること" do
    result = @client.books_software_search('2010-03-18', {:title => '会計', :os => 'Mac', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天ブックスジャンル検索APIの呼び出しが可能であること" do
    result = @client.books_genre_search('2009-03-26', {:booksGenreId => '000'})
    result['child'].should_not be_empty
    result['child'][0]['genreLevel'].should == 1
    result['child'][0]['genreName'].should_not be_nil
    result['child'][0]['genreId'].should_not be_nil
  end

  it "楽天ブックスジャンル検索APIの呼び出しが可能であること(DVD)" do
    result = @client.books_genre_search('2009-03-26', {:booksGenreId => '003'})
    result['child'].should_not be_empty
    result['child'][0]['genreLevel'].should == 2
    result['child'][0]['genreName'].should_not be_nil
    result['child'][0]['genreId'].should_not be_nil
  end

  # 
  # 楽天オークション系API
  # 

  it "楽天オークション商品検索APIの呼び出しが可能であること" do
    result = @client.auction_item_search('2010-09-15', {:keyword => '福袋', :sort => '+itemPrice'})
    (result['count'] > 0).should be_true
    result['Items']['Item'].should_not be_empty
  end

  it "楽天オークション商品コード検索APIの呼び出しが可能であること" do
    sample = @client.auction_item_search('2010-09-15', {:keyword => '福袋', :hits => 1})
    item_code = sample['Items']['Item'][0]['itemCode']
    # 楽天オークション商品コード検索API呼び出し.
    result = @client.auction_item_code_search('2010-09-15', {:itemCode => item_code})
    result['Items']['Item'].should_not be_empty
  end

  it "楽天オークションジャンル検索APIの呼び出しが可能であること" do
    result = @client.auction_genre_search('2010-09-15', {:auctionGenreId => '0'})
    result['child'].should_not be_empty
    result['child'][0]['genreLevel'].should == 1
    result['child'][0]['auctionGenreName'].should_not be_nil
    result['child'][0]['auctionGenreId'].should_not be_nil
  end

  it "楽天オークションジャンル検索APIの呼び出しが可能であること(レディースファッション)" do
    result = @client.auction_genre_search('2010-09-15', {:auctionGenreId => '1010000000'})
    result['child'].should_not be_empty
    result['child'][0]['genreLevel'].should == 2
    result['child'][0]['auctionGenreName'].should_not be_nil
    result['child'][0]['auctionGenreId'].should_not be_nil
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
#pp result
    #result['pagingInfo'][0]['recordCount'].should_not be_nil

    result = @client.vacant_hotel_search('2009-10-20', {:latitude => 128440.51, :longitude => 503172.21, :searchRadius => 1, :checkinDate => (Date.today + 1).to_s, :checkoutDate => (Date.today + 3).to_s, :adultNum => 2})
#pp result
    #result['recordCount'].should_not be_nil

    result = @client.vacant_hotel_search('2009-10-20', {:hotelNo => '2763,4624', :checkinDate => (Date.today + 1).to_s, :checkoutDate => (Date.today + 3).to_s, :maxCharge => 8500})
#pp result
    #result['recordCount'].should_not be_nil
  end
  
  it "楽天トラベル地区コードAPIの呼び出しが可能であること" do
    result = @client.get_area_class('2009-03-26')
#pp result
    # TODO: 2.0
  end

  it "楽天トラベルキーワード検索APIの呼び出しが可能であること" do
    result = @client.keyword_hotel_search('2009-10-20', {:keyword => '品川シーサイド'})
    result['hotel'].should_not be_empty
    result['pagingInfo'][0]['recordCount'].should_not be_nil
  end

  it "楽天トラベルホテルチェーンAPIの呼び出しが可能であること" do
    result = @client.get_hotel_chain_list('2009-05-12')
#pp result
    # TODO: 2.0
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

    # TODO: 2.0
  end
  
  #
  # その他のAPI
  #

  it "楽天GORAゴルフ場検索APIの呼び出しが可能であること" do
    result = @client.gora_golf_course_search('2010-06-30', {:keyword => '天然温泉', :sort => '50on'})
    result['Items']['Item'].should_not be_empty
    result['count'].should_not be_nil
  end

  it "楽天GORAゴルフ場詳細APIの呼び出しが可能であること" do
    sample = @client.gora_golf_course_search('2010-06-30', {:keyword => '天然温泉', :hits => 1})
    golf_course_id = sample['Items']['Item'][0]['golfCourseId']
    # 楽天GORAゴルフ場詳細APIの呼び出し
    result = @client.gora_golf_course_detail('2010-06-30', {:golfCourseId => golf_course_id})
    result['Item'].should_not be_empty
  end

end

# -*- coding: utf-8 -*-
require 'rakuten'
require 'date'
require 'pp'
require File.dirname(__FILE__) + '/ids.rb'

# see http://webservice.rakuten.co.jp/document/index.html

# テストを実行するには、ids.rb.sample のデベロッパーIDとアフィリエイトIDを書き換え、
# ids.rb という名前で保存してください.
describe Rakuten::DynamicAdClient do

  before(:all) do
    @developer_id = DEVELOPER_ID
    @affiliate_id = AFFILIATE_ID
    @client = Rakuten::DynamicAdClient.new(@developer_id, @affiliate_id)
  end

  it "楽天ダイナミックアドAPIの呼び出しが可能であること" do
    result = @client.dynamic_ad(nil, {:url => 'http://plaza.rakuten.co.jp/isblog/diary/200705230001/'})
    result['Ads']['Ad'].should_not be_empty
  end

  it "楽天GORAダイナミックAPIトラベルの呼び出しが可能であること" do
    result = @client.dynamic_ad_travel(nil, {:url => 'http://plaza.rakuten.co.jp/travelblog02/diary/200706140000/'})
    result['Ads']['Ad'].should_not be_empty
  end

end

# -*- coding: utf-8 -*-
require 'rakuten'
require 'date'
require 'pp'

# see http://webservice.rakuten.co.jp/document/index.html

describe Rakuten::DynamicAdClient do

  before(:all) do
    @developer_id = '0c40edce3a5222e2961780df16d0c0f6'
    @affiliate_id = '0d41c043.e0cdd459.0d41c044.5eaf1555'
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

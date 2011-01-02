# -*- coding: utf-8 -*-
require 'rakuten'
require 'date'
require 'pp'

# see http://webservice.rakuten.co.jp/document/index.html

describe Rakuten::DynamicAdClient do

  before(:all) do
    @developer_id = '45b4f149ff4bd93f284302da29e48b5c'
    @affiliate_id = '0d388c70.61fad632.0d388c76.be4fa787'
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

module DataMacros

  def test_client
    @test_client ||= UniSender::Client.new("2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w")
  end

  def available_list_ids
    test_client.getLists['result'].map{|list| list['id'].to_i}
  end

end

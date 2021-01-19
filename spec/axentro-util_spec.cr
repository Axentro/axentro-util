require "./spec_helper"

describe Axentro::Util do
  it "should create a valid signed transaction" do
    from_address = "VDAwZTdkZGNjYjg1NDA1ZjdhYzk1M2ExMDAzNmY5MjUyYjI0MmMwNGJjZWY4NjA3"
    from_public_key = "3a133bb891f14aa755af119907bd20c7fcfd126fa187288cc2b9d626552f6802"
    wif = "VDAwYjIxODI2NDg3MDE3YjA2YTYxOTJiYjUzMjg0MDAzZWNkZGRhZDJlYmUwNjMxYWM3NmIwMzFlYTg4MjlkMTBhMzBkZmNk"
    to_address = "VDBjY2NmOGMyZmQ0MDc4NTIyNDBmYzNmOWQ3M2NlMzljODExOTBjYTQ0ZjMxMGFl"
    amount = "1"

    transaction = Axentro::Util.create_signed_send_transaction(from_address, from_public_key, wif, to_address, amount)
    json = JSON.parse(transaction)["transaction"]

    sender = json["senders"].as_a.first
    sender["address"].as_s.should eq(from_address)
    sender["public_key"].as_s.should eq(from_public_key)
    sender["amount"].as_i.should eq(100000000)
    sender["fee"].as_i.should eq(10000)
    sender["signature"].as_s.size.should be > 30

    recipient = json["recipients"].as_a.first
    recipient["address"].as_s.should eq(to_address)
    recipient["amount"].as_i.should eq(100000000)
  end
end

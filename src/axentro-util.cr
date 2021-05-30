require "json"
require "monocypher"
require "big"
require "crest"

module Axentro::Util
  SCALE_DECIMAL = 8

  extend self

  def create_signed_send_transaction(from_address : String, from_public_key : String, wif : String, to_address : String, amount : String, fee : String = "0.0001", speed : String = "FAST")
    from_private_key = __get_private_key_from_wif(wif)
    __create_signed_send_token_transaction(from_address, from_public_key, from_private_key, to_address, amount, fee, speed)
  end

  def post_transaction(transaction_json, url : String = "https://mainnet.axentro.io")
    request = Crest::Request.new(:post, "#{url}/api/v1/transaction", headers: {"Content-Type" => "application/json"}, form: transaction_json)
    response = request.execute
    raise "status code was: #{response.status_code}" if response.status_code != 200
    json_response = JSON.parse(response.body)
    json_response["result"]["id"].as_s
  rescue e : Exception
    puts "Error sending transaction: #{e}"
  end

  def __create_signed_send_token_transaction(from_address : String, from_public_key : String, from_private_key : String, to_address : String, amount : String, fee : String = "0.0001", speed : String = "FAST")
    transaction_id = __create_id
    timestamp = __timestamp
    scaled_amount = __scale_i64(amount)
    scaled_fee = __scale_i64(fee)

    unsigned_transaction = %Q{{"id":"#{transaction_id}","action":"send","message":"","token":"AXNT","prev_hash":"0","timestamp":#{timestamp},"scaled":1,"kind":"#{speed}","version":"V1","senders":[{"address":"#{from_address}","public_key":"#{from_public_key}","amount":#{scaled_amount},"fee":#{scaled_fee},"signature":"0"}],"recipients":[{"address":"#{to_address}","amount":#{scaled_amount}}],"assets":[],"modules":[],"inputs":[],"outputs":[],"linked":""}}

    payload_hash = __sha256(unsigned_transaction)
    signature = __sign(from_private_key, payload_hash)
    signed_transaction = __to_signed(unsigned_transaction, signature)

    %Q{{"transaction": #{signed_transaction}}}
  end

  def __create_id : String
    tmp_id = Random::Secure.hex(32)
    return __create_id if tmp_id[0] == "0"
    tmp_id
  end

  def __timestamp : Int64
    Time.utc.to_unix_ms
  end

  def __sign(hex_private_key, payload_hash) : String
    secret_key = Crypto::SecretKey.new(hex_private_key)
    signature = Crypto::Ed25519Signature.new(payload_hash, secret: secret_key)
    signature.to_slice.hexstring
  end

  def __verify(signature_hex, hex_public_key, payload_hash) : String
    public_key = Crypto::Ed25519PublicSigningKey.new(hex_public_key)
    signature = Crypto::Ed25519Signature.new(signature_hex)
    signature.check(payload_hash, public: public_key)
  rescue e : Exception
    raise "Verify fail: #{e.message || "unknown verify fail"}"
  end

  def __to_signed(unsigned_transaction, signature) : String
    unsigned_transaction.gsub(%Q{"signature":"0"}, %Q{"signature":"#{signature}"})
  end

  def __sha256(base : Bytes | String) : String
    hash = OpenSSL::Digest.new("SHA256")
    hash.update(base)
    hash.final.hexstring
  end

  def __get_private_key_from_wif(wif)
    Base64.decode_string(wif)[2..-7]
  end

  def __scale_i64(value : String) : Int64
    BigDecimal.new(value).scale_to(BigDecimal.new(1, SCALE_DECIMAL)).value.to_i64
  end
end

require "jwt"

ISSUER_ID = "<issuer ID>"
KEY_ID =    "<key ID>"

payload = {
    iss: ISSUER_ID,
    iat: Time.now.to_i,
    exp: Time.now.to_i + 60 * 60
}

header = {
    alg: "ES256",   
    kid: KEY_ID  
}

key_file = File.read("AuthKey_#{KEY_ID}.p8")
private_key = OpenSSL::PKey::EC.new key_file
# private_key.check_key

public_key = OpenSSL::PKey::EC.new private_key
public_key.private_key = nil

token = JWT.encode(payload, private_key, "ES256", header_fields = header)
puts "----TOKEN----"
puts token

# decoded_token = JWT.decode token, public_key, true, { algorithm: 'ES256' }
# puts "Decoded token"
# puts decoded_token

puts "----CURL----"
puts "curl -v -H 'Authorization: Bearer #{token}' \"https://api.music.apple.com/v1/catalog/us/songs/302053341\""


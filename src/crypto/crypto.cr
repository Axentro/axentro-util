require "./hashes"
require "./key_ring"
require "./keys/*"
require "monocypher"
require "ed25519-hd"

module ::Axentro::Core
  class Node
    alias Network = NamedTuple(
      prefix: String,
      name: String,
    )
  end
end

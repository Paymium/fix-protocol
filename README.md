FIX Protocol [![Build Status](https://secure.travis-ci.org/Paymium/fix-protocol.png?branch=master)](http://travis-ci.org/Paymium/fix-protocol) [![Coverage Status](https://img.shields.io/coveralls/Paymium/fix-protocol.svg)](https://coveralls.io/r/Paymium/fix-protocol?branch=master) [![Gem Version](https://badge.fury.io/rb/fix-protocol.svg)](http://badge.fury.io/rb/fix-protocol)
=

This FIX protocol wrapper enables one to easily parse and create messages complying with the FIX 4.4 specification. 

It includes definitions for admin messages (logon, logout, reject, heartbeat, resend request, test request), for some market data messages (market data request, market data snapshot, and market data incremental refresh) as well as the ability to easily define other ones.

## Message creation example

Messages are created by instantiating the relevant message class and serialized using the `#dump` method.

````ruby
require 'fix/protocol'

msg = FP::Messages::Logon.new

msg.sender_comp_id  = 'MY_ID'
msg.target_comp_id  = 'MY_COUNTERPARTY'
msg.msg_seq_num     = 0
msg.username        = 'MY_USERNAME'

if msg.valid?
  puts msg.dump
else
  puts msg.errors.join(", ")
end
````

Which would output the sample message : `8=FIX.4.4\x019=105\x0135=A\x0149=MY_ID\x0156=MY_COUNTERPARTY\x0134=0\x0152=20141021-10:33:15\x0198=0\x01108=30\x01553=MY_USERNAME\x01141=\x0110=176\x01`


## Message definition example

Complex message definition is possible using a simple DSL as shown below.

````ruby
module Fix 
  module Protocol
    module Messages

      class MarketDataRequest < Message

        SUBSCRIPTION_TYPES = { 
          snapshot:     0,  
          updates:      1,  
          unsubscribe:  2
        }   

        MKT_DPTH_TYPES = { 
          full: 0,
          top:  1
        }   

        UPDATE_TYPES = { 
          full:         0,  
          incremental:  1
        }   

        unordered :body do
          field :md_req_id,                 tag: 262, required: true
          field :subscription_request_type, tag: 263, required: true, type: :integer, mapping: SUBSCRIPTION_TYPES
          field :market_depth,              tag: 264, required: true, type: :integer, mapping: MKT_DPTH_TYPES
          field :md_update_type,            tag: 265, required: true, type: :integer, mapping: UPDATE_TYPES

          collection :md_entry_types, counter_tag: 267, klass: FP::Messages::MdEntryType
          collection :instruments,    counter_tag: 146, klass: FP::Messages::Instrument  
        end 

      end 
    end 
  end 
end
````



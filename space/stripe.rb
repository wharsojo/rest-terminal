module Space
  class Stripe < SpaceBase
    private 

    def def_headers
      {
        :CONTENT_TYPE => 'application/x-www-form-urlencoded',
        :Authorization => "Basic #{Base64.encode64('c3jt7fG63gRdu5pxBnYy12fTODPVDnAq:')}"
      }
    end

    def def_vars
      {
        :timeout => 15,
        :url => 'https://api.stripe.com/v1/tokens',
        :body => [
          "card[number]=4242424242424242",
          "card[exp_month]=05",
          "card[exp_year]=2013",
          "card[cvc]=123"
          ].join('&') 
      }
    end
  end
end
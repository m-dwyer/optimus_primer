require_relative 'handler'

module OptimusPrimer
  class IntelXOrgHandler < DefaultHandler
    FEATURE_PATH = %i[intel xorg]

    include Handler
  end

  class NvidiaXOrgHandler < DefaultHandler
    FEATURE_PATH = %i[nvidia xorg]

    include Handler
  end
end
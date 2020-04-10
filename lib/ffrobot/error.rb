module FFRobot
    class Error < StandardError; end
    class NetError < Error; end
    class ExpiredApiKeyError < Error; end
end
class Job
    def initialize
      yield self if block_given?
    end
  
    def queue
      @queue = "express"
    end
  
    def name
      @name
    end

    def name=(in_name)
      @name = in_name
    end
  
    def mem
      @mem = "2000"
    end

  end
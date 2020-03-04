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

    def nodes
      @nodes = 1
    end

    def tasks
      @tasks = 1
    end

    def time
      @time = "00:05:00"
    end

    def param1
      @param1
    end

    def param1=(in_para)
      @param1 = in_para
    end

  end
# frozen_string_literal: true

task :default do
  tasks = %i[spec:parallel rubocop yard]

  executor = Class.new do
    # @param [Array] tasks
    #
    # @return [void]
    def execute(tasks)
      execute_parallel(tasks)
    end

    private

    # @param [Array] tasks
    #
    # @return [void]
    def execute_parallel(tasks)
      pids = tasks.map do |task_group|
        fork { execute_sequential(Array(task_group)) }
      end

      wait_processes(pids)
    end

    # @param [Array] task_group
    #
    # @return [void]
    def execute_sequential(task_group)
      task_group.each do |task|
        if task.is_a?(Array)
          execute_parallel(task)
        else
          invoke_task!(task)
        end
      end
    end

    # @param [String] task
    #
    # @return [void]
    def invoke_task!(task)
      Rake::Task[task].invoke
    end

    # @param [Array<Integer>] pids
    #
    # @return [void]
    def wait_processes(pids)
      pids.each do |pid|
        exit_code = Process.waitpid2(pid)[1] >> 8
        exit(exit_code) if exit_code.nonzero?
      end
    end
  end

  executor.new.execute(tasks)
end

module Rcqrs
	module Setting
		extend self

		def set(&block)
			yield self
		end

		# Accessor for the defaul database file for event storage
		# :api: public
		def default_database_file_path
			@default_database_file_path ||= 'config/event_storage.yml'
		end
		
		# Set the default file path for event storage database
		# :api: puiblic
		def default_database_file_path=(file_path)
			@default_database_file_path = file_path
		end

		# Set the default orm which will be used for event storage
		# for example: DataMapper, ActiveRecord
		# :api: public
		def default_orm=(orm)
			@default_orm = orm
		end
		
		# Accessor for the default orm for event storage
		# :api: public
		def default_orm
			@default_orm ||= :in_memory
		end
	end
end

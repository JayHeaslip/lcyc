revision_file = Rails.root.join('REVISION')

GIT_REVISION = if revision_file.exist?
                 revision_file.read.strip
               else
                 begin
                   `git rev-parse HEAD`.strip
                 rescue
                   'development'
                 end
               end

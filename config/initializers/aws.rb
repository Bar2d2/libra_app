# frozen_string_literal: true

Aws.config.update({
                    region: Rails.application.credentials.s3[:region],
                    credentials: Aws::Credentials.new(Rails.application.credentials.s3[:access_key_id], Rails.application.credentials.s3[:secret_access_key])
                  })

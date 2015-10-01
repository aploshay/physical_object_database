require 'singleton'

class DigitalFileAutoAcceptor
        include Singleton

        WINDOW_START = 23 * 60 # 11pm, in minutes
        WINDOW_STOP  = 24 * 60 # midnight, in minutes

        def aa_logger
                @@aa_logger ||= Logger.new("#{Rails.root}/log/auto_accept.log")
        end

        def start
		@@thread_active ||= false
		if @@thread_active
                  aa_logger.info("Auto accept thread already running at #{Time.now}")
		else
                  aa_logger.info("Auto accept thread started at #{Time.now}")
                  Thread.new {
			  @@thread_active = true
                          while true
                                  time = Time.now
                                  if in_time_window?(time)
                                          aa_logger.info("Auto accept thread running at #{time}")
                                          begin
                                                  auto_accept
                                          rescue Exception => e
                                                  aa_logger.info("EXCEPTION: #{e.inspect}")
                                          end
                                  else
                                          aa_logger.info("Auto accept thread skipped at #{time}")
                                  end
                                  # recalc time in case auto_accept ran for awhile
                                  time = Time.now
                                  sleep_duration = wait_seconds(time)
                                  aa_logger.info("Sleeping for #{sleep_duration} seconds until #{time + sleep_duration}")
                                  sleep(sleep_duration)
                          end
			  @@thread_active = false
                  }
		end
        end

        def total_mins(time)
                (time.hour * 60) + time.min
        end

        def in_time_window?(time)
                WINDOW_START <= total_mins(time) && total_mins(time) <= WINDOW_STOP
        end

        def wait_seconds(time)
                # wait until window start
                duration = (WINDOW_START - total_mins(time))
                # wrap around 24 hours if needed
                duration += WINDOW_STOP if duration < 0
                # convert to seconds
                duration * 60
        end

        def auto_accept
                audio = DigitalStatus.expired_audio_physical_objects
                aa_logger.info("Expired audio objects: #{audio.size}")
                audio.each do |po|
                        if po.current_digital_status.state == 'qc_wait'
                                po.current_digital_status.update_attributes(decided: 'qc_passed')
                        else
                                po.current_digital_status.update_attributes(decided: 'to_archive')
                        end
                        aa_logger.info("Auto accepting #{po.mdpi_barcode}, #{po.current_digital_status.state} -> #{po.current_digital_status.decided}")
                end
                video = DigitalStatus.expired_video_physical_objects
                aa_logger.info("Expired video objects: #{video.size}")
                video.each do |po|
                        if po.current_digital_status.state == 'qc_wait'
                                po.current_digital_status.update_attributes(decided: 'qc_passed')
                        else
                                po.current_digital_status.update_attributes(decided: 'to_archive')
                        end
                        aa_logger.info("Auto accepting #{po.mdpi_barcode}, #{po.current_digital_status.state} -> #{po.current_digital_status.decided}")
                end
        end


end

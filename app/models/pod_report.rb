class PodReport < ActiveRecord::Base
  validates :status, presence: true
  validates :filename, presence: true, uniqueness: true

  def destroy
    begin
      File.delete(full_path)
    rescue Errno::ENOENT
    end
    super
  end

  def complete?
    self.status == 'Available'
  end

  def full_path
    @full_path ||= Rails.root.join('public', 'reports', self.filename)
  end

  def display_size
    megabytes = (size.to_f / 2**20).round(0)
    if complete?
      megabytes.to_s
    elsif status.match '%'
      "#{megabytes} (projected total: #{(100.0 / (status.split('%').first.to_i.to_f) * megabytes).round})"
    else
      megabytes.to_s
    end    
  end

  def size
    begin
      File.size(self.full_path)
    rescue Errno::ENOENT
      0
    end
  end
end

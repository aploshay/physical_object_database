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
    return 'N/A' unless complete?
    (size.to_f / 2**20).round(0)
  end

  def size
    return 0 unless complete?
    begin
      File.size(self.full_path)
    rescue Errno::ENOENT
      0
    end
  end
end
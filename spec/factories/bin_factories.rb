FactoryBot.define do

  factory :bin, class: Bin do
    identifier "Test Bin"
    mdpi_barcode { BarcodeHelper.valid_mdpi_barcode }
    destination "IU"
    physical_location ""
  end

  trait :invalid do
    identifier nil
  end

  factory :invalid_bin, parent: :bin do
    identifier nil
  end

end

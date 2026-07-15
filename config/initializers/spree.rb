# Uncomment lines below to add your own custom business logic
# such as promotions, shipping methods, etc.
Rails.application.config do |config|
  config.to_prepare do
    unless Spree::Variant.ancestors.include?(SpreeAvailabilityNotifications::Spree::VariantDecorator)
      Spree::Variant.prepend SpreeAvailabilityNotifications::Spree::VariantDecorator
    end
  end

  # Spree.shipping_methods << Spree::ShippingMethods::SuperExpensiveNotVeryFastShipping
  # Spree.payment_methods << Spree::PaymentMethods::VerySafeAndReliablePaymentMethod

  # Spree.calculators.tax_rates << Spree::TaxRates::FinanceTeamForcedMeToCodeThis

  # Spree.stock_splitters << Spree::Stock::Splitters::SecretLogicSplitter

  # Spree.adjusters << Spree::Adjustable::Adjuster::TaxTheRich

  # Custom promotions
  # Spree.calculators.promotion_actions_create_adjustments << Spree::Calculators::PromotionActions::CreateAdjustments::AddDiscountForFriends
  # Spree.calculators.promotion_actions_create_item_adjustments << Spree::Calculators::PromotionActions::CreateItemAdjustments::FinanceTeamForcedMeToCodeThis
  # Spree.promotions.rules << Spree::Promotions::Rules::OnlyForVIPCustomers
  # Spree.promotions.actions << Spree::Promotions::Actions::GiftWithPurchase

  # Spree.taxon_rules << Spree::TaxonRules::ProductsWithColor

  # Spree.exports << Spree::Exports::Payments
  # Spree.reports << Spree::Reports::MassivelyOvercomplexReportForCfo
  config.after_initialize do
    if Spree.respond_to?(:storefront)
      partial = "spree_availability_notifications/head"

      unless Spree.storefront.partials.head.include?(partial)
        Spree.storefront.partials.head << partial
      end
    end

    if Spree.respond_to?(:admin)
      settings_nav = Spree.admin.navigation.settings

      settings_nav.add(
        :availability_notifications_reports,
        label: :availability_notifications_reports,
        url: -> { spree.admin_availability_notifications_path },
        icon: "arrow-loop-right"
      )
    end
  end

end


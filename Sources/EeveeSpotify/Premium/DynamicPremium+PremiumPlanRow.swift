import Foundation

func getPremiumPlanBadge() throws -> Data {
    let badge = YourPremiumBadge.with {
        $0.name = "Individual"
        $0.version = 2
        $0.colorCode = "#FFD2D7"
    }
    
    return try badge.serializedData()
}

func getPremiumPlanRowData(originalPremiumPlanRow: PremiumPlanRow) throws -> Data {
    var premiumPlanRow = originalPremiumPlanRow
    
    premiumPlanRow.planName = "Individual"
    premiumPlanRow.planIdentifier = "Individual"
    premiumPlanRow.colorCode = "#FFD2D7"
    
    return try premiumPlanRow.serializedData()
}

func getPlanOverviewData() throws -> Data {
    // 1. Calculate the billing date (10th of next month)
    let calendar = Calendar.current
    let now = Date()
    
    var components = calendar.dateComponents([.year, .month], from: now)
    components.month = (components.month ?? 1) + 1
    components.day = 10 // Updated billing day to the 10th
    
    let nextBillingDate = calendar.date(from: components) ?? now
    
    // 2. Format as M/d/yyyy
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d/yyyy"
    let formattedDateString = formatter.string(from: nextBillingDate)
    
    let plan = SpotifyPlan.with {
        $0.notice = SpotifyPlan.Notice.with {
            $0.message = "Your next bill is for $12.99 on \(formattedDateString). \nVisa ending in 4000"
            $0.status = 2 // 0 - trial, 1 - prepaid, 2 - subscription
        }
        $0.subscription = SpotifyPlan.SubscriptionInfo.with {
            $0.planVariant = 2
            $0.planName = "Individual"
            $0.planCategory = "Individual"
            $0.colorCode = "#FFD2D7"
            $0.features = [
                SpotifyPlan.Feature.with {
                    $0.color = "#1ED760"
                    $0.description_p = "ad_free_music_listening".localized
                    $0.icon = SpotifyPlan.IconType.check
                },
                SpotifyPlan.Feature.with {
                    $0.color = "#1ED760"
                    $0.description_p = "play_songs_in_any_order".localized
                    $0.icon = SpotifyPlan.IconType.check
                },
                SpotifyPlan.Feature.with {
                    $0.color = "#1ED760"
                    $0.description_p = "organize_listening_queue".localized
                    $0.icon = SpotifyPlan.IconType.check
                }
            ]
        }
    }
    
    return try plan.serializedData()
}

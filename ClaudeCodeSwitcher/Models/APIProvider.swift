import Foundation

struct APIProvider: Codable, Identifiable, Equatable {
    let id = UUID()
    var name: String
    var url: String
    var key: String
    var largeModel: String?
    var smallModel: String?
    
    enum CodingKeys: String, CodingKey {
        case name, url, key, largeModel, smallModel
    }
    
    init(name: String, url: String, key: String, largeModel: String? = nil, smallModel: String? = nil) {
        self.name = name
        self.url = url
        self.key = key
        self.largeModel = largeModel
        self.smallModel = smallModel
    }
    
    // 验证 API 密钥是否配置
    var isValid: Bool {
        return !name.isEmpty && !url.isEmpty && !key.isEmpty
    }
}

// MARK: - 使用量统计数据模型
struct UsageStats: Codable {
    let totalRequests: Int
    let totalTokens: Int
    let cost: Double
    let date: Date
    
    init(totalRequests: Int = 0, totalTokens: Int = 0, cost: Double = 0.0, date: Date = Date()) {
        self.totalRequests = totalRequests
        self.totalTokens = totalTokens
        self.cost = cost
        self.date = date
    }
}

// MARK: - 周统计汇总
struct WeeklyUsageStats {
    let totalRequests: Int
    let totalTokens: Int
    let totalCost: Double
    let dailyStats: [UsageStats]
    let averageRequestsPerDay: Double
    let peakDay: Date?
    
    init(dailyStats: [UsageStats]) {
        self.dailyStats = dailyStats
        self.totalRequests = dailyStats.reduce(0) { $0 + $1.totalRequests }
        self.totalTokens = dailyStats.reduce(0) { $0 + $1.totalTokens }
        self.totalCost = dailyStats.reduce(0) { $0 + $1.cost }
        
        let daysCount = max(dailyStats.count, 1)
        self.averageRequestsPerDay = Double(totalRequests) / Double(daysCount)
        
        // 找到请求量最高的一天
        self.peakDay = dailyStats.max(by: { $0.totalRequests < $1.totalRequests })?.date
    }
}

// MARK: - 使用量类型枚举
enum UsageMetricType: CaseIterable {
    case requests
    case tokens
    case cost
    
    var title: String {
        switch self {
        case .requests:
            return "请求次数"
        case .tokens:
            return "Token使用"
        case .cost:
            return "费用"
        }
    }
    
    var unit: String {
        switch self {
        case .requests:
            return "次"
        case .tokens:
            return "tokens"
        case .cost:
            return "$"
        }
    }
}
<div align="center">
  <img src="https://img.shields.io/badge/platform-iOS-blue?style=flat-square&logo=apple" />
  <img src="https://img.shields.io/badge/language-Objective--C-orange?style=flat-square" />
  <img src="https://img.shields.io/badge/SDK-MangoFixUtil%202.1.7-brightgreen?style=flat-square" />
  <img src="https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square" />
</div>

<br />

<p align="center">
  <h1 align="center">🔧 PatchHub</h1>
  <p align="center"><strong>MangoFix 热修复平台 · 让 iOS 应用修复快人一步</strong></p>
</p>

---

## 📖 简介

**PatchHub** 是基于 [MangoFix](https://github.com) 引擎构建的 iOS 热修复管理平台，为 iOS 开发者提供**一站式热修复解决方案**。

无需 App Store 审核，无需用户主动更新，**分钟级修复线上 Bug**，真正做到零感知、零等待。

| 特性 | 说明 |
|------|------|
| 🚀 **极速修复** | 从发现问题到全量修复，分钟级完成 |
| 🔒 **安全可靠** | AES + RSA 双重加密，保障补丁传输安全 |
| 📊 **全程可视** | 激活量、日活、日志全链路追踪 |
| 🎯 **精准控制** | 按应用、版本、规则灵活下发 |

---

## 🧩 核心功能

### 📱 应用管理
一键创建和管理多个 iOS 应用，支持 Bundle ID 配置、独立 RSA/AES 密钥管理、批量导出应用数据。

### 🔨 补丁管理
支持**开发模式**（单设备验证）和**生产模式**（全量下发）双模式发布。AES + RSA 双重加密，一键撤回或重新发布，实时查看补丁激活状态和下发量。

### 📈 日活统计
近 7 日滚动窗口实时展示各应用日活用户数，直观掌握应用健康度和用户活跃趋势。

### 🐛 在线日志
全量记录用户操作路径和页面详情，支持 IP 归属地追踪，按时间/应用筛选，精准定位问题场景。

### 📚 帮助文档
从 CocoaPods 接入到补丁开发发布，完整文档 + 常用 OC 代码片段 + 转换工具，开箱即用。

### 💬 用户反馈
内置反馈系统，支持富文本编辑提交，开发者可实时查看和处理用户反馈。

---

## ⚡ 快速接入

### 1. 安装 SDK

```ruby
# Podfile
target 'YourApp' do
  pod 'MangoFixUtil', '~> 2.1.7'
end
```

### 2. 初始化

```objc
// 获取单例对象
MangoFixUtil *util = [MangoFixUtil sharedUtil];

// 使用 AppId 初始化 SDK
[util startWithAppId:@"您的AppId"];
```

### 3. 开发补丁

```objc
// 修复示例：修正某个页面的标题
@implementation YourViewController (Fix)

- (void)viewDidLoad {
    [self viewDidLoad];
    self.title = @"正确的标题";
}

@end
```

### 4. 发布上线

登录 [PatchHub 控制台](https://patchhub.top/mangofix/login.html)，上传 `.mg` 补丁文件，选择目标应用和版本，一键发布即可生效。

---

## 🌐 在线访问

| 入口 | 链接 |
|------|------|
| 🏠 官方网站 | 本地 `index.html` |
| 🖥️ 管理控制台 | [patchhub.top/mangofix](https://patchhub.top/mangofix/login.html) |
| 📖 帮助文档 | [接入文档](https://patchhub.top/mangofix/helpInit) |

---

## 📞 联系我们

| 方式 | 信息 |
|------|------|
| 📧 邮箱 | `262316248@qq.com` |

---

## 📄 备案信息

- 粤ICP备2021037764号-1
- 粤公网安备 44190002005513号

---

<p align="center">
  <sub>Made with ❤️ for iOS Developers</sub>
</p>

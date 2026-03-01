# Moran ERP - AI开发工作流

## 项目概述

Moran ERP是一个基于微服务架构的珠宝行业ERP系统，使用Spring Boot 3.4 + Vue 3技术栈。项目采用AI自适应开发方法，通过细粒度任务管理和增量开发实现高效交付。

## 技术栈

**后端技术栈：**
- Java 21
- Spring Boot 3.4
- Spring Cloud (Gateway, Security, OAuth2)
- PostgreSQL
- Redis
- MyBatis Plus
- JWT

**前端技术栈：**
- Vue 3
- TypeScript
- Vite
- Element Plus
- Pinia
- Vue Router
- Axios

## AI开发工作流

### Phase 1: Initialize Environment & Context

在每次会话开始时，必须执行以下步骤来重建上下文：

#### 1.1 环境检查
```bash
# 确认当前目录
pwd

# 运行初始化脚本
./init.sh
```

#### 1.2 Git上下文重建
```bash
# 查看最近10次提交
git log --oneline -10

# 检查当前状态
git status
```

#### 1.3 项目进度同步
```bash
# 读取进度文件
cat progress.txt

# 读取任务清单
cat task.json
```

#### 1.4 环境健康检查
```bash
# 检查数据库连接
psql -h localhost -U postgres -d moran -c "SELECT 1" 2>/dev/null || echo "数据库连接失败"

# 检查后端服务（如果正在运行）
curl -f http://localhost:8080/actuator/health 2>/dev/null || echo "后端服务未运行"

# 检查前端服务（如果正在运行）
curl -f http://localhost:3000 2>/dev/null || echo "前端服务未运行"
```

#### 1.5 基础端到端测试
```bash
# 调用已知健康检查API
curl -f http://localhost:8080/actuator/health || echo "健康检查失败"

# 验证基本功能（例如，如果认证服务正在运行）
curl -f http://localhost:8080/api/auth/info || echo "认证功能检查失败"
```

### Phase 2: Select Next Task (Adaptive)

#### 2.1 读取任务清单
```bash
cat task.json
```

#### 2.2 环境能力评估
- **检测当前模型**：通过环境变量或系统提示判断当前使用的是GLM-5还是GLM-4.5
- **评估会话token限制**：根据历史经验判断当前会话的token容量
- **检查服务稳定性**：根据最近的成功/失败率评估服务稳定性

#### 2.3 任务选择策略

**规则1：优先选择有子任务的任务**
- 优先选择包含`subtasks`字段的任务
- 这样可以保证粒度控制和工作增量

**规则2：选择第一个未完成的子任务**
- 查找所有`passes: false`的任务
- 优先选择任务ID最小的未完成任务
- 在该任务中选择`passes: false`的第一个子任务

**规则3：根据模型能力调整任务粒度**
- **GLM-5 + 稳定环境**：可完成1-2个子任务
- **GLM-4.5 + 稳定环境**：只完成1个子任务
- **不稳定环境**：选择最小粒度任务或进一步拆分

**任务复杂度分级：**
- **简单任务**（单个文件创建、基础配置）：预计15-30分钟
- **中等任务**（Service实现、简单API）：预计30-60分钟
- **困难任务**（复杂业务逻辑、关联操作）：预计60-120分钟

#### 2.4 上下文准备
- 确保理解所选任务的依赖关系
- 检查前置任务是否已完成
- 准备相关技术文档和代码示例

### Phase 3: Implement Selected Task

#### 3.1 代码实现
- **遵循项目架构**：严格按照`architecture.md`定义的架构进行开发
- **代码规范**：遵循项目已有的代码风格和命名规范
- **渐进式开发**：如果任务复杂，分步骤实现，每步验证

#### 3.2 质量保证
- **单元测试**：为每个Service方法编写单元测试
- **集成测试**：为每个Controller编写集成测试
- **代码审查**：自我审查代码，确保符合最佳实践

#### 3.3 文档更新
- **API文档**：确保使用Swagger/OpenAPI注解
- **代码注释**：为复杂逻辑添加注释
- **更新进度**：在`progress.txt`中记录进展

### Phase 4: Test Thoroughly (Automated)

#### 4.1 后端测试自动化
```bash
# 运行单元测试
mvn test

# 运行集成测试
mvn integration-test

# 生成测试覆盖率报告
mvn jacoco:report
```

**测试要求：**
- **单元测试覆盖率**：最低80%
- **集成测试**：每个API至少测试成功、失败、边界情况
- **测试数据**：使用Testcontainers提供真实数据库环境
- **Mock策略**：使用Mockito模拟外部依赖

#### 4.2 前端测试自动化
```bash
# 运行单元测试
npm run test:unit

# 运行端到端测试
npm run test:e2e

# 生成测试报告
npm run test:report
```

**测试要求：**
- **组件测试**：使用@testing-library/vue测试组件渲染和交互
- **E2E测试**：使用Playwright进行真实浏览器自动化测试
- **API Mock**：使用MSW模拟后端API
- **用户场景**：模拟真实用户操作流程

#### 4.3 测试验证流程
1. **运行测试套件**：确保所有测试通过
2. **检查覆盖率**：确保达到最低覆盖率要求
3. **手动验证**：对于无法自动化的部分，进行手动验证
4. **性能检查**：关键接口进行基本的性能检查

### Phase 5: Update Progress & Commit Changes

#### 5.1 更新任务状态
```bash
# 更新task.json中对应子任务的passes为true
# 如果所有子任务完成，将主任务的passes设为true
```

#### 5.2 记录进展
```bash
# 在progress.txt中记录本次工作的详细信息
# 包括：
# - 完成的子任务
# - 遇到的问题和解决方案
# - 下次工作的建议
# - 环境状态变化
```

#### 5.3 代码提交
```bash
# 添加所有变更
git add .

# 创建提交信息（包含任务ID和子任务ID）
git commit -m "Task {taskId}.{subtaskId}: {子任务描述}"

# 推送到远程仓库
git push origin main
```

**提交信息格式：**
```
Task {taskId}.{subtaskId}: {子任务描述}

- 主要变更内容
- 解决的问题
- 影响的文件
```

### Phase 6: Clean up & Prepare for Next Session

#### 6.1 清理工作区
```bash
# 清理临时文件
mvn clean
npm run clean

# 检查是否有未提交的更改
git status
```

#### 6.2 记录下次工作
```bash
# 在progress.txt中记录下次应该从哪里开始
# 建议下一个要处理的子任务
# 记录任何需要特别注意的问题
```

#### 6.3 生成会话摘要
生成一个简短的会话摘要，包括：
- 本次会话完成的任务
- 当前项目状态
- 下次会话的建议起点

## 项目结构

```
moran-erp/
├── moran-common/
│   ├── moran-common-core/         # 核心工具、统一响应、异常处理
│   ├── moran-common-redis/        # Redis配置、分布式锁
│   ├── moran-common-security/     # OAuth2+JWT安全配置
│   └── moran-common-mybatis/      # MyBatis Plus配置、分页、审计
├── moran-gateway/                 # API网关
├── moran-auth/                    # 认证服务
├── moran-business/                # 核心业务服务
├── moran-external/                # 外部对接服务
├── moran-api/                     # Feign接口定义
└── pom.xml                        # 父POM

moran-web/
├── api/                          # API接口定义
├── assets/                       # 静态资源
├── components/                   # 通用组件
├── composables/                  # 组合式函数
├── layouts/                      # 布局组件
├── router/                       # 路由配置
├── stores/                       # Pinia状态管理
├── types/                        # TypeScript类型定义
├── utils/                        # 工具函数
├── views/                        # 页面组件
└── vite.config.ts               # Vite配置

auto-coding-agent-demo-main/
├── task.json                     # 细粒度任务清单
├── progress.txt                  # 项目进度记录
├── CLAUDE.md                     # AI开发工作流
└── init.sh                       # 环境初始化脚本
```

## 开发规范

### 代码风格
- **Java**：遵循Google Java Style Guide，使用2空格缩进
- **TypeScript**：遵循官方TypeScript风格指南，使用2空格缩进
- **命名规范**：
  - 类名：PascalCase
  - 方法名：camelCase
  - 变量名：camelCase
  - 常量名：UPPER_SNAKE_CASE

### Git规范
- **分支策略**：
  - `main`：主分支，保持可部署状态
  - `feature/*`：功能开发分支
  - `hotfix/*`：紧急修复分支
- **提交规范**：
  - feat: 新功能
  - fix: 修复bug
  - docs: 文档更新
  - style: 代码格式化
  - refactor: 重构
  - test: 测试相关
  - chore: 构建过程或辅助工具的变动

### API设计规范
- **RESTful设计**：
  - GET：查询资源
  - POST：创建资源
  - PUT：更新资源
  - DELETE：删除资源
- **响应格式**：
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {},
    "timestamp": "2024-01-01T00:00:00Z"
  }
  ```
- **错误处理**：
  - 使用统一的Result类封装响应
  - 使用BusinessException处理业务异常
  - 使用GlobalExceptionHandler处理全局异常

### 测试规范
- **单元测试**：
  - 使用JUnit 5
  - 使用Mockito模拟依赖
  - 测试覆盖率不低于80%
- **集成测试**：
  - 使用Testcontainers
  - 测试真实的数据库操作
  - 测试API的端到端流程
- **E2E测试**：
  - 使用Playwright
  - 模拟真实用户操作
  - 测试关键业务流程

## 常见问题和解决方案

### 问题1：MyBatis Plus LambdaWrapper缓存问题
**症状**：测试环境中LambdaWrapper出现缓存问题
**解决方案**：使用QueryWrapper替代LambdaWrapper
```java
// 错误：在测试环境中使用LambdaWrapper
LambdaQueryWrapper<Bom> wrapper = new LambdaQueryWrapper<>();
wrapper.eq(Bom::getProductId, productId);

// 正确：在测试环境中使用QueryWrapper
QueryWrapper<Bom> wrapper = new QueryWrapper<>();
wrapper.eq("product_id", productId);
```

### 问题2：Spring Boot参数名问题
**症状**：@RequestParam需要显式指定name属性
**解决方案**：
```java
// 错误：未指定name属性
@GetMapping("/boms")
public Result<List<BomVO>> getBoms(@RequestParam Integer pageNum) {}

// 正确：显式指定name属性
@GetMapping("/boms")
public Result<List<BomVO>> getBoms(@RequestParam(name = "pageNum") Integer pageNum) {}
```

### 问题3：Git提交冲突
**症状**：多个AI会话同时修改同一文件导致冲突
**解决方案**：
1. 每次开始前先pull最新代码
2. 完成任务后立即提交
3. 如果遇到冲突，手动解决后重新提交

### 问题4：测试环境不稳定
**症状**：测试环境连接不稳定导致测试失败
**解决方案**：
1. 增加重试机制
2. 使用容器化测试环境
3. 减少对外部依赖的测试

## 工具和资源

### 开发工具
- **IDE**：IntelliJ IDEA（后端）、VS Code（前端）
- **数据库工具**：DBeaver、pgAdmin
- **API测试**：Postman、Swagger UI
- **版本控制**：Git、GitHub

### 在线资源
- [Spring Boot 3.4 官方文档](https://docs.spring.io/spring-boot/docs/3.4.x/reference/html/)
- [Vue 3 官方文档](https://vuejs.org/)
- [MyBatis Plus 官方文档](https://baomidou.com/)
- [Element Plus 官方文档](https://element-plus.org/)

### 模板和示例
- **Service模板**：参考已有的ProductService
- **Controller模板**：参考已有的UserController
- **Vue组件模板**：参考已有的用户管理页面组件

## 总结

这个AI自适应开发工作流通过以下关键特性确保高效稳定的开发：

1. **细粒度任务管理**：将大任务拆分为子任务，减少单次负载
2. **上下文重建**：每次会话开始时重建完整的开发环境上下文
3. **动态适应性**：根据模型能力和环境稳定性调整任务粒度
4. **自动化测试**：确保代码质量和功能正确性
5. **增量进展**：通过频繁提交和进度跟踪确保项目稳步推进

通过遵循这个工作流，AI开发助手可以在GLM-4.5环境下稳定工作，在GLM-5环境下高效工作，最终实现高质量、高效率的软件交付。
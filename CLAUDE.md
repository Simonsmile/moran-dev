# Moran ERP - Project Instructions

## Project Context

珠宝行业ERP系统 - 微服务架构

后端: Java 21 + Spring Boot 3.4 + Spring Cloud Gateway + Nacos  
前端: Vue 3.5 + TypeScript + Element Plus + Pinia  
数据库: PostgreSQL 16  
部署: 阿里云 Ubuntu 22.04 (Docker)

> 详细项目需求请查看 architecture.md 和 task.json

---

## MANDATORY: Agent Workflow

Every new agent session MUST follow this workflow:

### Step 1: Initialize Environment

```bash
./init.sh
```

This will:
- 启动 Docker 容器 (PostgreSQL, Redis, RabbitMQ, Nacos)
- 安装后端 Maven 依赖
- 安装前端 npm 依赖
- 启动开发服务器

**DO NOT skip this step.** Ensure all services are running before proceeding.

### Step 2: Select Next Task

Read `task.json` and select ONE task to work on.

Selection criteria (in order of priority):
1. Choose a task where `passes: false`
2. Consider dependencies - fundamental features should be done first
3. Pick the lowest ID incomplete task (tasks are ordered by priority)

### Step 3: Implement the Task

- Read the task description and steps carefully
- Read `architecture.md` for design guidance
- Implement the functionality to satisfy all steps
- Follow existing code patterns and conventions
- Use Java 21 features where appropriate
- Follow Spring Boot best practices

### Step 4: Test Thoroughly

After implementation, verify ALL steps in the task:

**后端测试要求：**

1. **API开发**：
   - 编写单元测试 (JUnit 5 + Mockito)
   - 使用 `mvn test` 运行测试
   - 验证 API 返回格式符合 Result<T> 规范

2. **数据库相关**：
   - 验证实体类映射正确
   - 测试 CRUD 操作
   - 验证事务边界

3. **构建验证**：
   - `mvn clean compile` 编译成功
   - `mvn test` 测试通过
   - `mvn package` 打包成功

**前端测试要求：**

1. **页面开发**：
   - **必须在浏览器中测试！**
   - 验证页面能正确加载和渲染
   - 验证表单提交、按钮点击等交互功能

2. **构建验证**：
   - `npm run lint` 无错误
   - `npm run build` 构建成功
   - TypeScript 类型检查通过

**测试清单：**
- [ ] 代码编译无错误
- [ ] 单元测试通过
- [ ] lint/build 成功
- [ ] 功能在浏览器中正常工作（前端）

### Step 5: Update Progress

Write your work to `progress.txt`:

```
## [Date] - Task ID: [id] - [task title]

### What was done:
- [specific changes made]

### Testing:
- [how it was tested]

### Notes:
- [any relevant notes for future agents]
```

### Step 6: Commit Changes (包含 task.json 更新)

**IMPORTANT: 所有更改必须在同一个 commit 中提交，包括 task.json 的更新！**

流程：
1. 更新 `task.json`，将任务的 `passes` 从 `false` 改为 `true`
2. 更新 `progress.txt` 记录工作内容
3. 一次性提交所有更改：

```bash
git add .
git commit -m "feat: [task description] - completed"
```

**Commit Message 格式：**
- `feat: 新功能`
- `fix: 修复bug`
- `refactor: 重构`
- `docs: 文档更新`
- `test: 测试相关`
- `chore: 构建/工具相关`

**规则:**
- 只有在所有步骤都验证通过后才标记 `passes: true`
- 永远不要删除或修改任务描述
- 永远不要从列表中移除任务
- **一个 task 的所有内容（代码、progress.txt、task.json）必须在同一个 commit 中提交**

---

## Project Structure

```
/
├── CLAUDE.md              # This file - workflow instructions
├── task.json              # Task definitions (source of truth)
├── progress.txt           # Progress log from each session
├── architecture.md        # Architecture design document
├── init.sh                # Initialization script
│
├── moran-erp/             # Backend (Maven multi-module)
│   ├── moran-common/      # Common modules
│   │   ├── moran-common-core/
│   │   ├── moran-common-redis/
│   │   ├── moran-common-security/
│   │   └── moran-common-mybatis/
│   ├── moran-gateway/     # API Gateway
│   ├── moran-auth/        # Auth Service
│   ├── moran-business/    # Business Service
│   ├── moran-external/    # External Service
│   └── moran-api/         # Feign Interfaces
│
└── moran-web/             # Frontend (Vue 3)
    ├── src/
    │   ├── api/           # API interfaces
    │   ├── assets/        # Static resources
    │   ├── components/    # Common components
    │   ├── composables/   # Composition functions
    │   ├── directives/    # Custom directives
    │   ├── layouts/       # Layout components
    │   ├── router/        # Router config
    │   ├── stores/        # Pinia stores
    │   ├── types/         # TypeScript types
    │   ├── utils/         # Utilities
    │   └── views/         # Page components
    └── package.json
```

## Commands

```bash
# Backend (in moran-erp/)
mvn clean compile      # Compile
mvn test               # Run tests
mvn package -DskipTests  # Package without tests
mvn spring-boot:run    # Run service

# Frontend (in moran-web/)
npm run dev            # Start dev server
npm run build          # Production build
npm run lint           # Run linter
npm run preview        # Preview production build

# Docker
docker-compose up -d   # Start all containers
docker-compose down    # Stop all containers
docker-compose logs -f [service]  # View logs
```

## Coding Conventions

### Backend (Java)
- Java 21 features (records, pattern matching, virtual threads)
- Spring Boot 3.4 conventions
- RESTful API design
- Use `Result<T>` for unified response
- Use `@Valid` for request validation
- Write unit tests for services

### Frontend (Vue 3)
- Vue 3 Composition API (`<script setup>`)
- TypeScript strict mode
- Element Plus components
- Pinia for state management
- Composables for reusable logic

---

## ⚠️ 阻塞处理（Blocking Issues）

**如果任务无法完成测试或需要人工介入，必须遵循以下规则：**

### 需要停止任务并请求人工帮助的情况：

1. **缺少环境配置**：
   - 数据库连接需要真实密码
   - OAuth2 需要配置客户端
   - SSL 证书需要部署

2. **外部依赖不可用**：
   - 旺店通 API 需要真实密钥
   - 第三方服务需要开通账号

3. **测试无法进行**：
   - 需要真实用户账号测试
   - 需要阿里云服务器部署后测试

### 阻塞时的正确操作：

**DO NOT（禁止）：**
- ❌ 提交 git commit
- ❌ 将 task.json 的 passes 设为 true
- ❌ 假装任务已完成

**DO（必须）：**
- ✅ 在 progress.txt 中记录当前进度和阻塞原因
- ✅ 输出清晰的阻塞信息，说明需要人工做什么
- ✅ 停止任务，等待人工介入

### 阻塞信息格式：

```
🚫 任务阻塞 - 需要人工介入

**当前任务**: [任务ID] - [任务名称]

**已完成的工作**:
- [已完成的代码/配置]

**阻塞原因**:
- [具体说明为什么无法继续]

**需要人工帮助**:
1. [具体的步骤 1]
2. [具体的步骤 2]
...

**解除阻塞后**:
- 运行 [命令] 继续任务
```

---

## Key Rules

1. **One task per session** - Focus on completing one task well
2. **Test before marking complete** - All steps must pass
3. **Browser testing for UI changes** - 新建或大幅修改页面必须在浏览器测试
4. **Document in progress.txt** - Help future agents understand your work
5. **One commit per task** - 所有更改（代码、progress.txt、task.json）必须在同一个 commit 中提交
6. **Never remove tasks** - Only flip `passes: false` to `true`
7. **Stop if blocked** - 需要人工介入时，不要提交，输出阻塞信息并停止
8. **Read architecture.md first** - 了解整体架构设计

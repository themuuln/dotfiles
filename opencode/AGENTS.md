# Flutter GetX Project Guidelines

## ARCHITECTURE: MVC with GetX

- **Model**: Data classes and business logic
- **View**: Widget classes (UI only) - use `GetView<Controller>`
- **Controller**: State management via `GetxController`
- **Separation**: Views NEVER contain business logic

---

## CONVENTIONS

- **State**: `GetxController` + `.obs` variables. Consume with `Obx(() => ...)`.
- **Routing**: Always `Get.toNamed()`. Never `Navigator.push`.
- **DI**: Core controllers in `main.dart`. Access via `Get.find<T>()`.
- **Controller Split**: Large controllers use `part 'file.feature.dart'` + `extension ControllerFeature on Controller`.
- **UI Logic Isolation**: Use `[name].functions.dart` with extension on `_State` class to keep `build()` clean.
- **Feature Controllers**: Can live inside screen folder (e.g., `screens/story/story_controller.dart`).
- **Models**: Manual `fromJson`/`toJson`. All fields `final`. Named params.
- **Function Length**: STRICT 20 lines preferred (max 30). Functions must do ONE thing. Extract widgets/logic ruthlessly.

---

## CONTROLLER GUIDELINES

### Controller Structure (STRICT ORDER)

```dart
class HomeController extends GetxController {
  // 1. Reactive state variables (.obs)
  final count = 0.obs;
  final isLoading = false.obs;
  final user = Rxn<User>(); // Nullable reactive
  final items = <Item>[].obs; // List reactive
  
  // 2. Non-reactive dependencies
  final apiService = Get.find<ApiService>();
  
  // 3. Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Called after widget is rendered
  }
  
  @override
  void onClose() {
    // Dispose resources HERE
    super.onClose();
  }
  
  // 4. Public methods
  void increment() => count.value++;
  
  // 5. Private methods
  Future<void> _loadFromCache() async { }
}
```

### Controller Naming

- Always end with `Controller`: `HomeController`, `AuthController`, `ProductListController`

### Controller Creation Rules

| Method | Use Case |
|--------|----------|
| `Get.put()` | Persistent controllers needed immediately |
| `Get.lazyPut()` | Lazy initialization (RECOMMENDED) |
| `Get.create()` | New instance each time |
| `Get.putAsync()` | Async initialization (SharedPreferences, etc.) |

```dart
// In bindings or main.dart
Get.lazyPut<HomeController>(() => HomeController());
```

### One Controller Per Feature

- One controller per screen/feature unless shared state is needed
- Shared state (auth, theme, cart) → Global controllers in `main.dart`

---

## REACTIVE STATE MANAGEMENT

### Declaring Reactive Variables

```dart
final name = 'John'.obs;        // String
final count = 0.obs;            // int
final user = User().obs;        // Object
final userNullable = Rxn<User>(); // Nullable
final users = <User>[].obs;     // List
final userMap = <String, User>{}.obs; // Map
```

### Updating Reactive Variables

```dart
name.value = 'Jane';
count.value++;
user.value = User(name: 'New');
users.add(User());
users.assignAll(newList);       // Replace entire list
```

### Consuming Reactive State

| Widget | Use Case |
|--------|----------|
| `Obx(() => Widget)` | Small widgets, simple reactivity (PREFERRED) |
| `GetX<C>(builder:)` | When controller access needed in builder |
| `GetBuilder<C>(builder:)` | Non-reactive, manual `update()` calls |

```dart
// Obx - PREFERRED for small reactive widgets
Obx(() => Text('Count: ${controller.count.value}'))

// GetBuilder - for complex widgets, selective updates
GetBuilder<HomeController>(
  id: 'counter', // Optional ID
  builder: (c) => Text('Count: ${c.count}'),
)
// Update in controller: update(['counter']);
```

### CRITICAL: Wrap SMALLEST Widget Possible

```dart
// WRONG - entire column rebuilds
Obx(() => Column(
  children: [
    Text('Static'),
    Text('Count: ${controller.count.value}'),
    Text('More static'),
  ],
))

// CORRECT - only Text rebuilds
Column(
  children: [
    const Text('Static'),
    Obx(() => Text('Count: ${controller.count.value}')),
    const Text('More static'),
  ],
)
```

---

## DEPENDENCY INJECTION

### Using Bindings (RECOMMENDED)

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ApiService>(() => ApiService());
  }
}

// In routes
GetPage(
  name: '/home',
  page: () => HomeView(),
  binding: HomeBinding(),
)
```

### Finding Dependencies

```dart
final controller = Get.find<HomeController>();
```

---

## NAVIGATION

### Basic Navigation

```dart
Get.to(() => NextScreen());           // Push
Get.toNamed('/next');                  // Push named
Get.off(() => NextScreen());           // Replace
Get.offNamed('/next');                 // Replace named
Get.offAll(() => HomeScreen());        // Clear stack
Get.offAllNamed('/home');              // Clear stack named
Get.back();                            // Pop
Get.back(result: 'data');              // Pop with result
```

### Navigation with Arguments

```dart
// Send
Get.toNamed('/details', arguments: {'id': 123});

// Receive
final args = Get.arguments;
final id = args['id'];
```

### Navigation with URL Parameters

```dart
// Route definition: '/user/:id'
Get.toNamed('/user/123');

// Receive
final id = Get.parameters['id'];
```

---

## ROUTE MANAGEMENT

```dart
class AppPages {
  static const INITIAL = '/';
  static const HOME = '/home';
  static const DETAILS = '/details/:id';
  
  static final routes = [
    GetPage(
      name: INITIAL,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
  ];
}

// In main.dart
GetMaterialApp(
  initialRoute: AppPages.INITIAL,
  getPages: AppPages.routes,
)
```

---

## DIALOGS, SNACKBARS & BOTTOM SHEETS

```dart
// Snackbar
Get.snackbar(
  'Title',
  'Message',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.red,
  duration: const Duration(seconds: 3),
);

// Dialog
Get.defaultDialog(
  title: 'Alert',
  middleText: 'Message',
  onConfirm: () => Get.back(),
  onCancel: () => Get.back(),
);

// Bottom Sheet
Get.bottomSheet(
  Container(
    child: Wrap(children: [
      ListTile(
        leading: const Icon(Icons.music_note),
        title: const Text('Music'),
        onTap: () => Get.back(),
      ),
    ]),
  ),
  backgroundColor: Colors.white,
);
```

---

## WORKER FUNCTIONS (Reactive Programming)

```dart
@override
void onInit() {
  super.onInit();
  
  // Called EVERY time value changes
  ever(count, (value) => print('Changed: $value'));
  
  // Called ONCE on first change
  once(count, (value) => print('First change: $value'));
  
  // Called after inactivity (search input, etc.)
  debounce(
    searchQuery,
    (value) => performSearch(value),
    time: const Duration(milliseconds: 500),
  );
  
  // Called at fixed intervals during changes
  interval(
    scrollPosition,
    (value) => logScrollPosition(value),
    time: const Duration(seconds: 1),
  );
}
```

---

## GETXSERVICE (Persistent Services)

```dart
class SettingsService extends GetxService {
  final isDarkMode = false.obs;
  
  Future<SettingsService> init() async {
    await loadSettings();
    return this;
  }
  
  Future<void> loadSettings() async {
    // Load from SharedPreferences, etc.
  }
}

// Initialize in main.dart BEFORE runApp
await Get.putAsync(() => SettingsService().init());
```

---

## ERROR HANDLING PATTERN

```dart
class DataController extends GetxController {
  final isLoading = false.obs;
  final data = Rxn<DataModel>();
  final error = Rxn<String>();
  
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = null;
      
      data.value = await repository.getData();
      
    } on NetworkException catch (e) {
      error.value = 'Network error: ${e.message}';
      Get.snackbar('Error', error.value!);
    } catch (e) {
      error.value = 'An error occurred';
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## GETVIEW VS STATELESSWIDGET

### GetView (RECOMMENDED)

```dart
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // 'controller' automatically available
    return Scaffold(
      body: Obx(() => Text('${controller.count.value}')),
    );
  }
}
```

### StatelessWidget Alternative

```dart
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      body: Obx(() => Text('${controller.count.value}')),
    );
  }
}
```

---

## COMMON PATTERNS

### Loading State Pattern

```dart
Obx(() {
  if (controller.isLoading.value) {
    return const CircularProgressIndicator();
  }
  if (controller.error.value != null) {
    return Text('Error: ${controller.error.value}');
  }
  if (controller.data.value == null) {
    return const Text('No data');
  }
  return DataWidget(data: controller.data.value!);
})
```

### Pagination Pattern

```dart
class ListController extends GetxController {
  final items = <Item>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  int _page = 1;
  
  Future<void> fetchItems() async {
    if (isLoading.value || !hasMore.value) return;
    
    try {
      isLoading.value = true;
      final newItems = await repository.getItems(_page);
      
      if (newItems.isEmpty) {
        hasMore.value = false;
      } else {
        items.addAll(newItems);
        _page++;
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refresh() async {
    _page = 1;
    hasMore.value = true;
    items.clear();
    await fetchItems();
  }
}
```

### Authentication Pattern

```dart
class AuthController extends GetxController {
  final isAuthenticated = false.obs;
  final user = Rxn<User>();
  
  Future<void> login(String email, String password) async {
    final result = await repository.login(email, password);
    await storage.saveToken(result.token);
    isAuthenticated.value = true;
    user.value = result.user;
    Get.offAllNamed(AppRoutes.HOME);
  }
  
  Future<void> logout() async {
    await storage.deleteToken();
    isAuthenticated.value = false;
    user.value = null;
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
```

---

## PERFORMANCE BEST PRACTICES

### DO's

- Use `Obx` for small reactive widgets
- Use `GetBuilder` for complex non-reactive widgets
- Use `.obs` ONLY for UI-affecting state
- Dispose controllers with `Get.delete<Controller>()`
- Use `Bindings` for dependency management
- Use `lazyPut` for deferred initialization
- Wrap SMALLEST possible widget with `Obx`
- Use `const` constructors everywhere possible

### DON'Ts

- Don't wrap entire screens with `Obx`
- Don't make everything reactive
- Don't create controllers with `new` keyword
- Don't forget `super.onInit()` / `super.onClose()`
- Don't use `setState` (unnecessary with GetX)
- Don't access `.value` inside `Obx` if not needed

---

## QUICK REFERENCE

### State Management
| Code | Purpose |
|------|---------|
| `var.obs` | Make reactive |
| `var.value` | Access/modify |
| `Obx(() => W)` | Reactive rebuild |
| `GetBuilder<C>()` | Manual rebuild |

### Navigation
| Code | Purpose |
|------|---------|
| `Get.to(W)` | Push |
| `Get.back()` | Pop |
| `Get.off(W)` | Replace |
| `Get.offAll(W)` | Clear & push |

### DI
| Code | Purpose |
|------|---------|
| `Get.put<T>(T)` | Create & persist |
| `Get.lazyPut<T>(() => T)` | Lazy create |
| `Get.find<T>()` | Retrieve |

### Utilities
| Code | Purpose |
|------|---------|
| `Get.snackbar()` | Show snackbar |
| `Get.dialog()` | Show dialog |
| `Get.bottomSheet()` | Show bottom sheet |
| `context.width` | Screen width |
| `GetUtils.isEmail()` | Validation |

---

## LEGENDARY CODE QUALITY (STRICT)

- **Strict Typing**: Explicit types ALWAYS. No `var` (unless obvious), no `dynamic`, no `any`.
- **Immutability**: `final` everywhere. If it changes, it belongs in a `GetxController`.
- **Widget Extraction**: Extract UI to `StatelessWidget` classes with `const` constructors. NEVER use helper methods for widgets.
- **Guard Clauses**: Return early. Avoid `else`. Flatten nested logic.
- **Async Hygiene**: strictly `await` or `unawaited`. No dangling Futures.
- **Const Correctness**: Use `const` literals and constructors aggressively.
- **No Magic Numbers**: Extract ALL constants to `constants/`.
- **Meaningful Names**: Variables name "what" it is. Logic explains "why".
- **No `print()`**: STRICTLY FORBIDDEN. Use `the_log` package. Production apps don't spam stdout.
- **Zombie Code**: Delete commented-out code immediately. Git history exists for a reason.
- **Member Ordering**: `static const` -> `final` fields -> `constructor` -> `lifecycle` -> `public` -> `private`.
- **Theme First**: Never hardcode colors/styles in widgets. Use `AppColors` or `Theme.of(context)`.
- **Import Discipline**: Standard ordering: `dart:` -> `package:` -> `relative`.
- **One Class, One File**: Filenames match class names. Keep files small and focused.

---

## ANTI-PATTERNS (THIS PROJECT)

- **flutter_bloc**: In pubspec but **FORBIDDEN**. Use GetX only.
- **Navigator.pop(context)**: Use `Get.back()` in controllers.
- **Logic in build()**: Move to controller or `[name].functions.dart` extension.
- **Direct API calls from UI**: Route through `lib/api/` classes.
- **BuildContext in controllers**: Use `Get.context`, `Get.dialog()`, `Get.bottomSheet()`.
- **json_serializable**: Not used. All models are hand-written.
- **setState**: Never use - GetX handles reactivity.
- **Wrapping entire screens in Obx**: Wrap smallest widget possible.
- **Making everything reactive**: Only UI-affecting state needs `.obs`.

---

## PROJECT STRUCTURE

```
lib/
├── main.dart
├── app/
│   ├── data/
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── providers/
│   │   │   └── api_provider.dart
│   │   └── repositories/
│   │       └── user_repository.dart
│   ├── modules/
│   │   ├── home/
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart
│   │   │   └── views/
│   │   │       └── home_view.dart
│   │   └── auth/
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── core/
│       ├── theme/
│       ├── utils/
│       ├── values/
│       └── widgets/
└── services/
    └── settings_service.dart
```

---

## CODE GENERATION CHECKLIST

When generating GetX code, ensure:

1. [ ] Controllers extend `GetxController`
2. [ ] Views use `GetView<Controller>` or `Get.find<Controller>()`
3. [ ] Reactive state uses `.obs` and `.value`
4. [ ] Navigation uses GetX methods (`Get.to`, `Get.back`, etc.)
5. [ ] Dependencies injected via Bindings or `Get.lazyPut`
6. [ ] Lifecycle methods call `super` first/last appropriately
7. [ ] Smallest possible widgets wrapped in `Obx`
8. [ ] Routes defined in centralized `AppPages`
9. [ ] Proper error handling with try/catch/finally
10. [ ] Resources disposed in `onClose()`

---

## MCP TOOLING & CAPABILITIES

This workspace is equipped with **Dart & Flutter MCP** tools. Use these preferentially over raw shell commands for better context and safety.

### 1. Initialization (REQUIRED)

- **Start**: Always initialize the session by registering the project root.
  - Tool: `dart-mcp-server_add_roots(roots=[{uri: "file:///absolute/path/to/project"}])`

### 2. Development Loop

- **Run App**: Use `dart-mcp-server_launch_app` to run on simulators/devices.
  - _Benefit_: Returns a process ID (PID) for controlling the app.
- **Hot Reload**: Use `dart-mcp-server_hot_reload` after **EVERY** code change to apply updates immediately.
- **Logs**: Use `dart-mcp-server_get_app_logs` to stream structured logs.
- **Restart**: Use `dart-mcp-server_hot_restart` to reset state.

### 3. Debugging & Inspection

- **Widget Tree**: `dart-mcp-server_get_widget_tree` to see the actual UI hierarchy.
- **Runtime Errors**: `dart-mcp-server_get_runtime_errors` for active exceptions.
- **Symbol Lookup**: `dart-mcp-server_resolve_workspace_symbol` to find definitions quickly.

### 4. Code Maintenance

- **Analysis**: `dart-mcp-server_analyze_files` (Superior to `flutter analyze`).
- **Auto-Fix**: `dart-mcp-server_dart_fix` to automatically apply linter fixes.
- **Deps**: `dart-mcp-server_pub` for adding/removing packages.

---

## COMMANDS

```bash
# Run
flutter run

# Code gen (Envied only)
dart run build_runner build --delete-conflicting-outputs

# Analyze (Legacy - prefer MCP analyze_files)
flutter analyze
```

---

# GIT COMMIT PROTOCOL

**Objective:**
Create atomic, well-structured commits following company standards. Agent analyzes changes and commits directly without confirmation.

## Execution Workflow

### 1. Multi-Group Detection (MANDATORY)

Before committing, analyze if changes belong to **different logical scopes**:

| Scenario | Action |
|----------|--------|
| Changes in `auth` + changes in `ui` | SPLIT into separate commits |
| Feature code + unrelated refactor | SPLIT into separate commits |
| Single cohesive change | Single commit |

**If splitting is needed:**
1. `git reset` to unstage everything
2. For each logical group:
   - `git add <specific_files>`
   - Execute commit (see format below)

### 2. Commit Message Format (STRICT)

```text
type(scope): subject in english

Detailed description in Mongolian.
```

### 3. Format Rules

| Element | Rule |
|---------|------|
| **Type** | One of: `feat`, `fix`, `docs`, `chore`, `ref`, `feat!` |
| **Scope** | MANDATORY. Format: `lower_snake_case` (e.g., `auth_service`, `login_ui`) |
| **Subject** | English. Imperative mood. No period. Max 50 chars. |
| **Body** | Mongolian. Explains the "why", not the "what". |

### 4. Examples

```text
feat(story_player): add swipe navigation between stories

Хэрэглэгч түүхнүүд хооронд шудрах боломжтой болсон.
Энэ нь UX-ийг сайжруулж, Instagram-тэй төстэй туршлага өгнө.
```

```text
fix(auth_service): handle token refresh race condition

Олон request зэрэг токен сэргээхийг оролдоход гарч байсан 
race condition-ийг mutex ашиглан шийдсэн.
```

```text
ref(api_provider): extract retry logic to separate mixin

Retry логикийг ApiRetryMixin-д гаргаж, код давтагдахаас сэргийлсэн.
DRY зарчмыг баримталсан.
```

### 5. Execution Instructions

- **DO NOT** ask for confirmation
- **DO NOT** output the command as text
- **DIRECTLY RUN** `git add` and `git commit` commands
- **VERIFY** with `git log -1` after commit

---

# WORKFLOW PROTOCOL: ISOLATION REQUIRED

Whenever I give you a new coding task, you must NEVER modify the current working directory directly if it is the main branch or root of the repo.

**Step 0: Git Repository Check (PREREQUISITE)**

- Run `git rev-parse --git-dir` to verify git is initialized.
- **If NOT a git repository:** Skip worktree creation entirely. Work directly in the current directory.
- **If IS a git repository:** Proceed to Step 1.

**Step 1: Check Context**

- Check if we are currently inside a specific git worktree for this task.
- If not, you must create one immediately.

**Step 2: Create Worktree (Enhanced)**

- Generate a branch name from the task description (e.g., `feat/add-login`).
- Run: `./scripts/worktree_manager.sh create <branch-name>`
- **Features Active:**
  - **Shadow Storage:** Worktree is created in `~/.opencode_worktrees/` to keep root clean.
  - **Instant Start:** `node_modules` are symlinked and `.env` files copied automatically.
  - **tmux Sync:** If in tmux, a new window `OC:<branch>` is spawned.
- **CRITICAL:** You must `cd` into the path reported by the script before making edits.

**Step 3: Execution**

- Only then, proceed with the task.

---

# PROTOCOL: TASK COMPLETION & MERGE

**Trigger Keywords:**
When I say "finished", "done", "test completed", or "merge this", you must initiate the Merge Sequence.

**Step 1: Verification**

- **Run Tests:** Execute the project's test suite.
- **Run Static Analysis:** If this is a Flutter project, you MUST run `flutter analyze` (or MCP equivalent) and ensure it returns zero issues.
- **If Tests or Analysis Fail:** STOP. Do not merge. Fix the errors first.
- **If All Pass:** Proceed to Step 2.

**Step 2: Commit & Snapshot**

- Ensure the working tree is clean: `git add .`
- Run: `./scripts/worktree_manager.sh cleanup <branch-name>`
- **Note:** This takes a "Snapshot" commit of your current state and pushes it to origin before removing the worktree.

**Step 3: The Merge Dance (CRITICAL)**

1. **Switch Context:** Go back to the main repo root.
2. **Merge:**
   - `git checkout main` (or `dev`).
   - `git pull origin main`.
   - `git merge --no-ff <branch-name>`.
3. **Cleanup:**
   - `git branch -d <branch-name>` (Local branch deletion).

**Step 4: Report**

- "Task completed, merged to main, and worktree cleaned up. Ready for next task."

---

# Log Driven Development (LDD)

## Protocol

The LDD workflow standardizes debugging on mobile devices (iOS/Android) where direct debugger attachment is difficult or impossible. It relies on high-fidelity structured logging to reconstruct state and control flow.

1.  **Instrumentation:** Agent proactively injects structured logging into code paths.
2.  **Reproduction:** User performs the workflow on the device.
3.  **Extraction:** User provides raw console output or log files.
4.  **Analysis:** Agent parses logs to pinpoint failure modes, timing issues, or state corruption.

## User Role

- Reproduce the reported issue on the physical device.
- Capture the full log stream (e.g., via Xcode Console, ADB, or file export).
- Paste the raw logs into the chat for analysis.

## Agent Role

- **Proactive Logging:** Always add logging to new features _during implementation_, not just after bugs are found.
- **Pattern Matching:** Analyze timestamps and sequences to detect race conditions.
- **Sanitization Check:** Verify that suggested logging code does not expose secrets.

## Log Standards

Adhere strictly to this structured format to ensure parseability:

**Format:**
`[Category] Message {metadata}`

- **Category:** The subsystem or feature area (e.g., `[Auth]`, `[BLE]`, `[Nav]`).
- **Message:** A clear, human-readable description of the event.
- **Metadata:** A key-value set (JSON-style) containing variable state, IDs, or error codes.

## Safety

- **Conditional Compilation:** Wrap debug logs in `#if DEBUG` (Swift) or `if (BuildConfig.DEBUG)` (Kotlin) to protect production performance and binary size.
- **Data Privacy:** **NEVER** log PII (emails, names), Auth Tokens, or Passwords.
- **Sanitization:** Always mask sensitive IDs (e.g., `userId: ***52a`) before logging.

## Gold Standard Example

```text
[Network] User profile fetch failed {status=401, endpoint="/api/v1/me", duration_ms=150, error="Token expired"}
```

---

# AGENT CHANGELOG PROTOCOL

**Objective:**
Maintain a granular history of agent-performed tasks for auditability and tracking.

**1. Location & Structure**

- Root directory: `./changelogs/`
- Date-based subdirectories: `./changelogs/YYYY-MM-DD/`
- File naming: `<HHMM>-<kebab-case-task-name>.md`
  - Example: `changelogs/2026-01-26/1430-refactor-auth-middleware.md`

**2. Content Template**
Each changelog file must contain:

- **Task**: The original user request or ticket.
- **Changes**: Bullet points of key modifications.
- **Files**: List of touched files.
- **Verification**: How the changes were verified (tests, manual checks).

**3. Execution Timing**

- Create this log entry **before** initiating the "Task Completion & Merge" sequence.

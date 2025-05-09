# Solução para o problema de Hot Reload no Flutter Injections

Este guia apresenta a solução para o problema de perda de estado durante hot reloads, especialmente para ViewModels e outras injeções singleton.

## O Problema

Durante hot reloads, o Flutter destrói e recria widgets, mas mantém o estado dos StatefulWidgets. Porém, os objetos injetados como singleton pelo flutter_injections estavam sendo recriados, resultando em:

1. Perda de estado dos ViewModels
2. Falha ao navegar entre telas
3. Serviços se reconectando desnecessariamente

Especificamente, havia um problema ao navegar da SplashScreen para a LoginPage onde o LoginViewModel não era encontrado.

## A Solução Implementada

Fizemos as seguintes melhorias:

1. Criamos uma instância global de `FlutterInjections` que persiste entre hot reloads
2. Implementamos um sistema para preservar e restaurar singletons
3. Melhoramos a detecção de hot reloads
4. Adicionamos logs detalhados para depuração

## Como usar corretamente o sistema modificado

### 1. Sempre declare ViewModels como singletons

```dart
class LoginModule extends FlutterModule {
  const LoginModule({super.key});

  @override
  Widget get child => const LoginPage();

  @override
  List<Inject<Object>> get injections => [
        Inject<LoginViewModel>(
          (i) => LoginViewModel(
            gerenciadorLoginService: i.find<IGerenciadorLoginService>(),
          ),
          type: InjectType.singleton, // Importante: use sempre InjectType.singleton
        ),
      ];
}
```

### 2. Use BlocProvider para gerenciar o ciclo de vida do ViewModel

Na LoginPage, prefira usar o BlocProvider em vez de acessar diretamente o FlutterInjections:

```dart
@override
Widget build(BuildContext context) {
  // Use o BlocProvider para fornecer o ViewModel
  return BlocProvider<LoginViewModel>.value(
    value: FlutterInjections.get<LoginViewModel>(),
    child: BlocConsumer<LoginViewModel, LoginState>(
      listener: (context, state) {
        // código de tratamento do estado
      },
      builder: (context, state) {
        // construção da UI
      },
    ),
  );
}
```

### 3. Ative o sistema de logs para depuração

Em caso de problemas, ative o sistema de logs para ver detalhes sobre o ciclo de vida das injeções:

```dart
void initState() {
  super.initState();
  // Ativar logs detalhados durante desenvolvimento
  FlutterInjections.setLogLevel(2);
}
```

### 4. Ordem de inicialização dos módulos

Certifique-se de que os serviços necessários sejam injetados antes dos ViewModels que dependem deles:

```dart
// No AppModule, mantenha uma ordem lógica de dependências
@override
List<Inject<Object>> get injections => [
  // 1. Infraestrutura
  ...infraInjections,
  
  // 2. Repositórios 
  ...repositoryInjections,
  
  // 3. Serviços
  ...serviceInjections,
  
  // 4. ViewModels
  ...viewModelInjections,
];
```

## Exemplo específico para resolver o problema do LoginViewModel

1. Garanta que o IGerenciadorLoginService seja injetado como singleton:

```dart
// Em algum módulo carregado antes do LoginModule
Inject<IGerenciadorLoginService>(
  (i) => GerenciadorLoginService(
    // dependências
  ),
  type: InjectType.singleton,
),
```

2. Modifique a LoginPage para usar corretamente o ViewModel:

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    try {
      // Obter a instância já injetada
      _viewModel = FlutterInjections.get<LoginViewModel>();
      print("LoginViewModel encontrado com sucesso");
    } catch (e) {
      print("Erro ao obter LoginViewModel: $e");
      // Tratamento de fallback
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.state == LoginEnum.success) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          // outros tratamentos de estado
        },
        builder: (context, state) {
          // construção da UI
        },
      ),
    );
  }
}
```

## Verificação de Problemas

Se ainda enfrentar problemas, verifique:

1. Se o LoginViewModel está sendo injetado corretamente como singleton
2. Se a ordem de inicialização dos módulos está correta
3. Se não há exceções durante a inicialização de dependências
4. Se o sistema de navegação não está recriando widgets desnecessariamente

## Logs para Depuração

Ative os logs completos e procure por:

1. `FlutterInjections - Criando nova instância global`
2. `FlutterInjections - Usando instância global existente (hot reload = true)`
3. `FlutterInjections - Preservados N singletons durante hot reload: [lista de tipos]`
4. `FlutterInjections - Reutilizando singleton existente: LoginViewModel`

Se você não vir essas mensagens, pode haver um problema no ciclo de preservação de singletons. 
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get about => 'Sobre';

  @override
  String get account => 'Conta';

  @override
  String get achievements => 'Conquistas';

  @override
  String get active => 'Ativo';

  @override
  String get activeDays => 'Dias ativos';

  @override
  String get adFreeExperience => 'Experiência sem anúncios';

  @override
  String get add => 'Adicionar';

  @override
  String get addDate => 'Adicionar Data';

  @override
  String get addEvent => 'Adicionar Evento';

  @override
  String get addFabTooltip => 'Adicionar';

  @override
  String get addFirstTransaction => 'Adicionar primeira transação';

  @override
  String get addHabit => 'Adicionar Hábito';

  @override
  String get addHabitToRoomPrompt => 'Adicione um hábito à sala com o botão +!';

  @override
  String get addImage => 'Adicionar imagem';

  @override
  String get addNew => 'Adicionar novo';

  @override
  String get addNewHabit => 'Adicionar Novo Hábito';

  @override
  String get addOptionHint => 'Adicionar opção...';

  @override
  String get addOptionsToStart => 'Adicionar opções para começar';

  @override
  String get addRoomButton => 'Adicionar Sala';

  @override
  String get addSpecialDays => 'Adicionar dias especiais';

  @override
  String get addSubtask => 'Adicionar Subtarefa';

  @override
  String get addTask => 'Adicionar Tarefa';

  @override
  String get addText => 'Adicionar texto';

  @override
  String get addToList => 'Adicionar à lista';

  @override
  String addedToRoomSnackbar(Object title) {
    return '$title adicionado à sala! 🎯';
  }

  @override
  String get advancedAnalysis => 'Análise Avançada';

  @override
  String get advancedAnalysisAndReports => 'Análise e relatórios avançados';

  @override
  String get simpleHabit => 'Hábito simples';

  @override
  String get advancedHabit => 'Hábito avançado';

  @override
  String get advancedHabitSubtitle =>
      'Premium • Criar hábito com configurações detalhadas';

  @override
  String get advancedHabitTitle => 'Hábito Avançado';

  @override
  String get advancedHabitTypeDescription =>
      'Metas numéricas, temporizadores e rastreamento detalhado.';

  @override
  String get advancedTimer => 'Temporizador Avançado';

  @override
  String get aiAssistantOnline => 'Online';

  @override
  String get aiAssistantTitle => 'Assistente Mira';

  @override
  String aiContextMessage(Object tip) {
    return 'Olá! Notei que você se interessou por esta dica:\n\n\"$tip\"\n\nGostaria que eu mostrasse como aplicar isso no Mira?';
  }

  @override
  String aiHabitAddedMessage(int count) {
    return '$count hábitos adicionados via IA';
  }

  @override
  String get aiInputHint => 'Descreva o hábito que você quer criar...';

  @override
  String get aiPoweredRecommendations => 'Recomendações via IA';

  @override
  String get aiPreviewTitle => 'Sugestões da IA';

  @override
  String get aiQuickFinance => 'Dicas de orçamento';

  @override
  String get aiQuickGamification => 'Explicar sistema de XP';

  @override
  String get aiQuickHabit => 'Criar um novo hábito';

  @override
  String get aiQuickMood => 'Analisar meu humor';

  @override
  String get aiQuickMotivation => 'Me dê motivação';

  @override
  String get aiQuickProfile => 'Meu Personagem de IA';

  @override
  String get aiQuickTimer => 'Como usar o Timer?';

  @override
  String get aiQuickVision => 'Ajuda com o Mural de Visão';

  @override
  String get aiRetry => 'Repetir com Regras Estritas';

  @override
  String get aiShowMeHow => 'Sim, mostre-me como';

  @override
  String get aiTip0 =>
      'Você sabia? Você pode criar um Mural de Visão para seus objetivos de longo prazo.';

  @override
  String get aiTip1 =>
      'Dica: Use o Temporizador para sessões de trabalho focadas.';

  @override
  String get aiTip2 =>
      'Rastreie seu humor diariamente para ver padrões ao longo do tempo.';

  @override
  String get aiTip3 =>
      'Hábitos fixam melhor quando feitos no mesmo horário todos os dias.';

  @override
  String get aiTip4 =>
      'Divida grandes Visões em tarefas menores e gerenciáveis.';

  @override
  String get aiTip5 =>
      'Use a guia Finanças para acompanhar seus gastos diários.';

  @override
  String get aiTip6 =>
      'Precisa de ajuda? Toque aqui para perguntar ao assistente de IA!';

  @override
  String get aiTip7 => 'Consistência é a chave! Não quebre a corrente.';

  @override
  String get aiWelcomeMessage =>
      'Olá! Sou seu assistente Mira. Como posso ajudar você hoje? Você pode me perguntar como usar visões, hábitos, temporizadores ou qualquer outro recurso.';

  @override
  String get allDataDeleted => 'Todos os dados foram excluídos';

  @override
  String get allHabitsLabel => 'Todos os Hábitos';

  @override
  String get allLabel => 'Todos';

  @override
  String get alsoDeleteLinkedHabits => 'Também excluir hábitos vinculados';

  @override
  String get amount => 'Quantidade';

  @override
  String get amountLabel => 'Valor';

  @override
  String get analysis => 'Análise';

  @override
  String get analysisTooltip => 'Análise';

  @override
  String get annualPlanDesc => 'Acesso ininterrupto por 12 meses';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'Aparência';

  @override
  String get apply => 'Aplicar';

  @override
  String get applyCode => 'Aplicar Código';

  @override
  String get applying => 'Aplicando...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'Esta visão dura cerca de $days dias';
  }

  @override
  String get assetsReloadHint =>
      'Pode ser necessário reiniciar o app completamente para carregar alguns recursos.';

  @override
  String get atLeast => 'Pelo Menos';

  @override
  String get atMost => 'No Máximo';

  @override
  String get autoBackupSubtitle =>
      'Faça backup automático dos seus dados no Google Drive a cada 24 horas.';

  @override
  String get autoBackupTitle => 'Backup Automático';

  @override
  String get averageMood => 'Humor Médio';

  @override
  String get back => 'Voltar';

  @override
  String get backgroundPlate => 'Placa de fundo';

  @override
  String get backupError => 'Erro de Backup';

  @override
  String get backupFailed => 'Backup falhou';

  @override
  String get backupNow => 'Fazer Backup Agora';

  @override
  String get backupRestore => 'Backup e Restauração';

  @override
  String backupSuccess(Object id) {
    return 'Backup concluído: $id';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupToDrive => 'Backup para o Drive';

  @override
  String get badgeActive100dDesc => 'Fique ativo por 100 dias diferentes';

  @override
  String get badgeActive100dTitle => '100 Dias Ativo';

  @override
  String get badgeActive30dDesc => 'Fique ativo por 30 dias diferentes';

  @override
  String get badgeActive30dTitle => '30 Dias Ativo';

  @override
  String get badgeActive7dDesc => 'Fique ativo por 7 dias diferentes';

  @override
  String get badgeActive7dTitle => '7 Dias Ativo';

  @override
  String get badgeCategoryActivity => 'Atividade';

  @override
  String get badgeCategoryFinance => 'Finanças';

  @override
  String get badgeCategoryHabit => 'Hábito';

  @override
  String get badgeCategoryLevel => 'Nível';

  @override
  String get badgeCategoryVision => 'Visão';

  @override
  String get badgeCategoryXp => 'Experiência';

  @override
  String get badgeFin100Desc => 'Registre 100 transações';

  @override
  String get badgeFin100Title => 'Guru das Finanças';

  @override
  String get badgeFin10Desc => 'Registre 10 transações';

  @override
  String get badgeFin10Title => 'Econômico';

  @override
  String get badgeFin250Desc => 'Registre 250 transações';

  @override
  String get badgeFin250Title => 'Banqueiro';

  @override
  String get badgeFin50Desc => 'Registre 50 transações';

  @override
  String get badgeFin50Title => 'Economista';

  @override
  String get badgeHabit100Desc => 'Conclua 100 hábitos no total';

  @override
  String get badgeHabit100Title => 'Especialista';

  @override
  String get badgeHabit10Desc => 'Conclua 10 hábitos no total';

  @override
  String get badgeHabit10Title => 'Iniciante';

  @override
  String get badgeHabit200Desc => 'Conclua 200 hábitos no total';

  @override
  String get badgeHabit200Title => 'Lenda';

  @override
  String get badgeHabit50Desc => 'Conclua 50 hábitos no total';

  @override
  String get badgeHabit50Title => 'Consistente';

  @override
  String get badgeLevel10Desc => 'Alcance o nível 10';

  @override
  String get badgeLevel10Title => 'Viajante';

  @override
  String get badgeLevel20Desc => 'Alcance o nível 20';

  @override
  String get badgeLevel20Title => 'Mestre';

  @override
  String get badgeLevel5Desc => 'Alcance o nível 5';

  @override
  String get badgeLevel5Title => 'Aprendiz';

  @override
  String get badgeVision10Desc => 'Crie 10 visões';

  @override
  String get badgeVision10Title => 'Futurista';

  @override
  String get badgeVision1Desc => 'Crie sua primeira visão';

  @override
  String get badgeVision1Title => 'Sonhador';

  @override
  String get badgeVision5Desc => 'Crie 5 visões';

  @override
  String get badgeVision5Title => 'Visionário';

  @override
  String get badgeVisionHabits3Desc => 'Vincule 3+ hábitos a uma visão';

  @override
  String get badgeVisionHabits3Title => 'Focado em Metas';

  @override
  String get badgeXp1000Desc => 'Acumule 1000 XP no total';

  @override
  String get badgeXp1000Title => 'Sábio';

  @override
  String get badgeXp500Desc => 'Acumule 500 XP no total';

  @override
  String get badgeXp500Title => 'Experiente';

  @override
  String get badges => 'Emblemas';

  @override
  String balanceParenthesis(Object balance) {
    return '(Saldo: $balance)';
  }

  @override
  String get becomePremium => 'Torne-se Premium';

  @override
  String get becomePremiumShort => 'Obter Premium';

  @override
  String get between1And360 => 'Entre 1 e 360';

  @override
  String get billingHistory => 'Histórico de Cobrança';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Uma breve biografia sobre você';

  @override
  String get breakLabel => 'PAUSA';

  @override
  String get breakTime => 'Pausa';

  @override
  String get breakdownByCategory => 'Detalhamento por categoria';

  @override
  String get bringForward => 'Trazer para frente';

  @override
  String bugReportFailedError(Object error) {
    return 'Falha ao enviar relatório de bug: $error';
  }

  @override
  String bugReportFailedStatus(Object statusCode) {
    return 'Falha ao enviar relatório de bug: $statusCode';
  }

  @override
  String get bugReportSentSuccess =>
      'Seu relatório de bug foi enviado com sucesso. Obrigado!';

  @override
  String get buyPremium => 'Comprar Premium';

  @override
  String get canIGetRefund => 'Posso receber um reembolso?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get cancelEffect =>
      'Você continuará a desfrutar dos recursos premium até que sua assinatura termine.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Assinaturas → Mira Plus → Cancelar';

  @override
  String get cannotOpenPlayStore => 'Não foi possível abrir a Play Store';

  @override
  String get category => 'Categoria';

  @override
  String get categoryName => 'Nome da Categoria';

  @override
  String get characterDescBalancedMindful =>
      'Você é calmo, estável e valoriza a paz interior. Você se destaca em manter o equilíbrio e abordar a vida com atenção plena e serenidade.';

  @override
  String get characterDescExplorer =>
      'Você é curioso, criativo e ama variedade. Você prospera aprendendo coisas novas e tentando diferentes abordagens para os desafios da vida.';

  @override
  String get characterDescPlanner =>
      'Você é organizado, focado em metas e prefere ter uma estrutura. Você é excelente em transformar sonhos em planos acionáveis e segui-los com disciplina.';

  @override
  String get characterDescSocialConnector =>
      'Você é caloroso, empático e se energiza através dos relacionamentos. Você encontra sentido em se conectar com os outros e construir comunidades fortes.';

  @override
  String get characterTypeBalancedMindful => 'Equilibrado e Consciente';

  @override
  String get characterTypeExplorer => 'Explorador';

  @override
  String get characterTypePlanner => 'Planejador';

  @override
  String get characterTypeSocialConnector => 'Conector Social';

  @override
  String get checkboxType => 'Caixa de Seleção';

  @override
  String get checkboxTypeDesc => 'Marcação simples';

  @override
  String get checkingPurchases => 'Verificando compras...';

  @override
  String get chooseBestCategory => 'Escolha a melhor categoria para seu hábito';

  @override
  String get chooseColor => 'Escolher Cor:';

  @override
  String get chooseEmoji => 'Escolher Emoji:';

  @override
  String get choosePhoto => 'Escolher Foto';

  @override
  String get choosePhotoDesc => 'Selecione uma foto que inspire você';

  @override
  String get choosePhotoSubtitle => 'Escolha uma foto para te motivar';

  @override
  String get clear => 'Limpar';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get clearHistory => 'Limpar Histórico';

  @override
  String get close => 'Fechar';

  @override
  String get closeButton => 'Fechar';

  @override
  String get cloudBackup => 'Backup na Nuvem';

  @override
  String get coinFlipDescription => 'Decida entre duas opções';

  @override
  String get coinFlipInstruction => 'Digite duas opções e jogue a moeda!';

  @override
  String get coinFlipTitle => 'Cara ou Coroa';

  @override
  String get colorLabel => 'Cor';

  @override
  String get colorTheme => 'Tema de cores';

  @override
  String get completeAllSubtasksToFinish =>
      'conclua tudo para finalizar o hábito';

  @override
  String get completedSelectedDay => 'Concluído (dia selecionado)';

  @override
  String get completedTableHeader => 'FEITO';

  @override
  String get completionPercentLabel => '% Concluído';

  @override
  String completionsCount(Object count) {
    return '$count conclusões';
  }

  @override
  String get confirmDeleteAccount => 'Confirmar Exclusão de Conta';

  @override
  String get confirmHabits => 'Confirmar Hábitos';

  @override
  String get continueAsGuest => 'Continuar como Convidado';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueText => 'Continuar';

  @override
  String get copyButton => 'Copiar';

  @override
  String get copyCodeTitle => 'Copiar Código';

  @override
  String costTokens(Object cost) {
    return 'Custo: $cost tokens';
  }

  @override
  String get cottonCandy => 'Doce de Algodão';

  @override
  String get cottonCandyDesc => 'Doce de algodão - rosa e azul';

  @override
  String get countdownConfigureTitle => 'Configurar Contagem Regressiva';

  @override
  String get countdownLabel => 'CONTAGEM REGRESSIVA';

  @override
  String get cozyJournal => 'Diário Aconchegante';

  @override
  String get cozyJournalDesc => 'Tons de marrom e linha do tempo';

  @override
  String get crashReports => 'Relatórios de erro';

  @override
  String get crashReportsSubtitle =>
      'Enviar relatórios anônimos quando o app fechar inesperadamente';

  @override
  String get create => 'Criar';

  @override
  String get createAdvancedHabit => 'Criar Hábito Avançado';

  @override
  String get createButton => 'Criar';

  @override
  String get createDailyTask => 'Criar Tarefa Diária';

  @override
  String get createFirstHabit => 'Criar Hábito';

  @override
  String get createFirstReportPrompt =>
      'Clique no botão + para criar seu primeiro relatório semanal';

  @override
  String get createFirstVision => 'Crie Sua Primeira Visão';

  @override
  String get createHabit => 'Criar Hábito';

  @override
  String get createHabitAction => 'Criar Hábito';

  @override
  String get createHabitTemplateTitle => 'Criar Modelo de Hábito';

  @override
  String get createHabitTitle => 'Criar Hábito';

  @override
  String get createList => 'Criar Lista';

  @override
  String get createNewCategory => 'Criar Nova Categoria';

  @override
  String get createNewList => 'Criar nova lista';

  @override
  String get createReport => 'Criar Relatório';

  @override
  String get createRoomSubtitle => 'Crie uma nova sala e convide seus amigos';

  @override
  String get createRoomSuccessSnackbar => 'Sala criada! 🎉';

  @override
  String get createRoomTitle => 'Criar Sala';

  @override
  String get createVision => 'Criar Visão';

  @override
  String get createVisionTemplateTitle => 'Criar Modelo de Visão';

  @override
  String get createVisionWithAI => 'Criar Visão com IA';

  @override
  String get createWithAi => 'Criar com IA';

  @override
  String get creatingBackup => 'Criando backup...';

  @override
  String get currentStreak => 'Sequência Atual';

  @override
  String get custom => 'Personalizado';

  @override
  String get customCategories => 'Categorias Personalizadas';

  @override
  String get customEmoji => 'Emoji Personalizado';

  @override
  String get customEmojiHint => 'Ex: ✨';

  @override
  String get customEmojiOptional => 'Emoji personalizado (opcional)';

  @override
  String get customEvent => 'Evento Personalizado';

  @override
  String get customFrequency => 'Personalizado';

  @override
  String get customUnit => 'Unidade Personalizada';

  @override
  String get customUnitHint => 'Ex: porção, série, km...';

  @override
  String get daily => 'Diário';

  @override
  String get dailyCheck => 'Verificação diária';

  @override
  String get dailyDesc => 'Todos os dias';

  @override
  String get dailyHabitInfo => 'Diário';

  @override
  String get dailyLimit => 'Limite diário';

  @override
  String get dailyTask => 'Tarefa Diária';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Tarefa diária criada: $title';
  }

  @override
  String get dailyTaskSubtitle => 'Adicione uma tarefa específica para hoje';

  @override
  String get dailyTaskTitle => 'Tarefa Diária';

  @override
  String get dailyTasksSection => 'Tarefas Diárias';

  @override
  String get darkTheme => 'Tema escuro';

  @override
  String get dashboard => 'Painel';

  @override
  String get date => 'Data';

  @override
  String get dateRangeLabel => 'Intervalo de Datas';

  @override
  String get dayFriShort => 'Sex';

  @override
  String get dayMonShort => 'Seg';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'Dia $start–$end';
  }

  @override
  String get daySatShort => 'Sáb';

  @override
  String dayShort(Object day) {
    return 'Dia $day';
  }

  @override
  String get daySunShort => 'Dom';

  @override
  String get dayThuShort => 'Qui';

  @override
  String get dayTueShort => 'Ter';

  @override
  String get dayWedShort => 'Qua';

  @override
  String get days => 'dias';

  @override
  String daysAgo(Object days) {
    return '$days dias atrás';
  }

  @override
  String daysAverageShort(Object days) {
    return '${days}d média';
  }

  @override
  String daysCount(Object count) {
    return '$count dias';
  }

  @override
  String get daysInterval => 'dias';

  @override
  String get daysIntervalLabel => 'intervalo de dias';

  @override
  String daysLater(Object days) {
    return 'em $days dias';
  }

  @override
  String get daysLeft => 'dias restantes';

  @override
  String get daysRemaining => 'Dias Restantes';

  @override
  String get daysSuffixShort => 'd';

  @override
  String get decisionEggDescription =>
      'Escolha um ovo místico para obter respostas';

  @override
  String get decisionEggTitle => 'Ovo da Decisão';

  @override
  String get defaultUnit => 'unidade';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteAccountFailed => 'Falha ao excluir conta';

  @override
  String get deleteAccountRequestSuccess =>
      'Seu pedido de exclusão de conta foi recebido com sucesso';

  @override
  String get deleteAccountSubtitle =>
      'Solicitar a exclusão de sua conta e dados';

  @override
  String get deleteAccountWarning =>
      'Esta ação não pode ser desfeita. Por favor, confirme o e-mail associado à sua conta.';

  @override
  String get deleteAction => 'Excluir';

  @override
  String get deleteAllData => 'Excluir todos os dados';

  @override
  String get deleteAllDataConfirmContent =>
      'Tem certeza de que deseja excluir todos os seus dados do aplicativo? Esta ação não pode ser desfeita.';

  @override
  String get deleteButton => 'Excluir';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return 'Excluir a categoria \"$name\"?';
  }

  @override
  String get deleteCategoryTitle => 'Excluir categoria';

  @override
  String get deleteCustomCategoryConfirm =>
      'Excluir esta categoria personalizada?';

  @override
  String get deleteEntryConfirm =>
      'Tem certeza de que deseja excluir esta entrada?';

  @override
  String get deleteEvent => 'Excluir Evento';

  @override
  String deleteHabitConfirm(Object title) {
    return 'Excluir \'$title\' da sala?';
  }

  @override
  String get deleteHabitTitle => 'Excluir Hábito';

  @override
  String get deleteListMessage =>
      'Esta lista será excluída. Escolha o que fazer com os itens vinculados:';

  @override
  String get deleteListTitle => 'Excluir Lista';

  @override
  String get deleteMyAccount => 'Excluir Minha Conta';

  @override
  String get deleteRoomTitle => 'Excluir Sala';

  @override
  String get deleteRoomWarning =>
      'Esta sala e todo o seu conteúdo serão excluídos permanentemente. Deseja continuar?';

  @override
  String get deleteTaskConfirm =>
      'Tem certeza de que deseja excluir esta tarefa?';

  @override
  String get deleteTaskConfirmMessage =>
      'Deseja excluir esta tarefa diária? Esta ação pode ser desfeita.';

  @override
  String get deleteTaskConfirmTitle => 'Excluir tarefa?';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'Excluir o registro \"$title\"?';
  }

  @override
  String get deleteVisionMessage => 'Excluir esta visão?';

  @override
  String get deleteVisionTitle => 'Excluir visão';

  @override
  String get descHint => 'Detalhes sobre seu hábito (opcional)';

  @override
  String get descriptionHintOptional => 'Adicionar descrição (opcional)';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get detailedCharts => 'Gráficos e estatísticas detalhados';

  @override
  String get diagnosticsData => 'Dados de diagnóstico';

  @override
  String get diagnosticsDataSubtitle =>
      'Compartilhar estatísticas de uso anônimas';

  @override
  String get difficulty => 'Nível de Dificuldade';

  @override
  String get drinkWater => 'Beber Água';

  @override
  String get duration => 'Duração';

  @override
  String get durationAutoLabel => 'Duração (auto)';

  @override
  String get durationIndefinite => 'Indefinida';

  @override
  String durationMonths(Object count) {
    return '$count meses';
  }

  @override
  String get durationSelection => 'Seleção de duração';

  @override
  String get durationType => 'Tipo de Duração';

  @override
  String get earthTheme => 'Terra';

  @override
  String get earthThemeDesc => 'Cores da terra';

  @override
  String get easy => 'Fácil';

  @override
  String get edit => 'Editar';

  @override
  String get editButton => 'Editar';

  @override
  String get editCategory => 'Editar Categoria';

  @override
  String get editDeleteTooltip => 'Editar / Excluir';

  @override
  String get editEvent => 'Editar Evento';

  @override
  String get editHabit => 'Editar Hábito';

  @override
  String get editListTitle => 'Editar Lista';

  @override
  String get editOnlyPersonalHabits =>
      'Você só pode editar hábitos que foram adicionados à sua lista pessoal.';

  @override
  String get education => 'Educação';

  @override
  String get eggRevealMessage => 'O ovo místico falou! ✨';

  @override
  String get eggSelectMessage => 'Pense em uma pergunta e toque em um ovo 🥚';

  @override
  String get emojiAndColor => 'Emoji e Cor';

  @override
  String get emojiCategoryAnimals => 'Animais';

  @override
  String get emojiCategoryCare => 'Cuidado';

  @override
  String get emojiCategoryFood => 'Comida';

  @override
  String get emojiCategoryHealth => 'Saúde';

  @override
  String get emojiCategoryLife => 'Vida';

  @override
  String get emojiCategoryNature => 'Natureza';

  @override
  String get emojiCategoryPopular => 'Populares';

  @override
  String get emojiCategoryProductivity => 'Produtividade';

  @override
  String get emojiCategorySport => 'Esporte';

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get emotionBlessed => 'Abençoado';

  @override
  String get emotionBored => 'Entediado';

  @override
  String get emotionConfident => 'Confiante';

  @override
  String get emotionConfused => 'Confuso';

  @override
  String get emotionDistracted => 'Distraído';

  @override
  String get emotionEuphoric => 'Eufórico';

  @override
  String get emotionGuilty => 'Culpado';

  @override
  String get emotionHopeful => 'Esperançoso';

  @override
  String get emotionInsecure => 'Inseguro';

  @override
  String get emotionLonely => 'Solitário';

  @override
  String get emotionNumb => 'Insensível';

  @override
  String get emotionOverwhelmed => 'Sobrecarregado';

  @override
  String get emotionProud => 'Orgulhoso';

  @override
  String get emotionRegretful => 'Arrependido';

  @override
  String get emotionUnstoppable => 'Imparável';

  @override
  String get emptyHabitSubtitle =>
      'Crie seu primeiro hábito para começar a acompanhar seu progresso.';

  @override
  String get emptyHabitTitle => 'Inicie Sua Jornada';

  @override
  String get enableNotifications => 'Ativar Notificações';

  @override
  String get enableReminder => 'Ativar Lembrete';

  @override
  String get endDate => 'Data de Término';

  @override
  String get endDateLabel => 'Fim';

  @override
  String get endDayOptionalLabel => 'Dia final (opcional)';

  @override
  String get endTime => 'Hora de Término';

  @override
  String get enterBothOptions => 'Por favor, insira ambas as opções';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Insira um plano mensal para calcular um limite diário.';

  @override
  String get enterNameAndDesc => 'Insira o nome e a descrição do seu hábito';

  @override
  String get enterPromoCode => 'Por favor, insira um código promocional';

  @override
  String get enterValueTitle => 'Inserir valor';

  @override
  String get enterYourName => 'Insira seu nome';

  @override
  String get entries => 'Entradas';

  @override
  String get entryCountLabel => 'Contagem de Entradas';

  @override
  String get entrySaved => 'Entrada salva com sucesso!';

  @override
  String get errorPrefix => 'Erro: ';

  @override
  String get eventDescription => 'Descrição';

  @override
  String get eventDetails => 'Detalhes do Evento';

  @override
  String get eventTitle => 'Título do Evento';

  @override
  String get every => 'Cada';

  @override
  String get everyDay => 'Todo dia';

  @override
  String get everyLabel => 'Cada';

  @override
  String everyNDays(Object days) {
    return 'A cada $days dias';
  }

  @override
  String everyNDaysInfo(Object days) {
    return 'Ocorre a cada $days dias';
  }

  @override
  String get everyNDaysQuestion => 'A cada quantos dias?';

  @override
  String everyXDays(Object periodicDays) {
    return 'A cada $periodicDays dias';
  }

  @override
  String get everyday => 'Todos os Dias';

  @override
  String get exact => 'Exato';

  @override
  String get exactAlarmPermission => 'Permissão de Alarme Exato (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return 'Exemplo: $example';
  }

  @override
  String get expenseDelta => 'Delta de Despesas';

  @override
  String get expenseDistributionPie => 'Distribuição de despesas (pizza)';

  @override
  String get expenseEditTitle => 'Editar Despesa';

  @override
  String get expenseLabel => 'Despesa';

  @override
  String get expenseNewTitle => 'Nova Despesa';

  @override
  String failedToLoad(Object error) {
    return 'Falha ao carregar: $error';
  }

  @override
  String get featureAdvancedFinance => 'Recursos Financeiros Avançados';

  @override
  String get featureAdvancedHabits => 'Criação de Hábito Avançada';

  @override
  String get featureAiBioClock => 'Relógio Biológico via IA';

  @override
  String get featureAiBioClockDesc =>
      'Timing ideal com base no seu ritmo biológico';

  @override
  String get featureAiWeeklyReport => 'Relatório Semanal via IA';

  @override
  String get featureAiWeeklyReportDesc =>
      'Análise detalhada de IA do seu progresso';

  @override
  String get featureBackup => 'Recurso de Backup';

  @override
  String get featurePremiumThemes => 'Temas Premium';

  @override
  String get featureVisionCreation => 'Criação de Visão';

  @override
  String get feelingMoreSpecific =>
      'Vamos descrever esse sentimento mais detalhadamente';

  @override
  String get filterTitle => 'Filtrar';

  @override
  String get filterTooltip => 'Filtrar';

  @override
  String get finance => 'Finanças';

  @override
  String get financeAddAiStatementOption => 'Carregar Extrato/Recibo com IA';

  @override
  String get financeAddAiStatementSubtitle =>
      'Adiciona automaticamente via imagem ou PDF';

  @override
  String get financeAddManualOption => 'Adicionar Manualmente';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Análise Financeira · $month';
  }

  @override
  String get financeLast7Days => 'Finanças · Últimos 7 dias';

  @override
  String get financeNet => 'Líquido';

  @override
  String get finish => 'Finalizar';

  @override
  String get fitness => 'Fitness';

  @override
  String get fixedDuration => 'Fixo';

  @override
  String get flexiblePlan => 'Plano flexível, cancele a qualquer momento';

  @override
  String get flipCoin => 'Jogar Moeda';

  @override
  String get focusLabel => 'FOCO';

  @override
  String get focusedZen => 'Zen Focado';

  @override
  String get focusedZenDesc => 'Minimalista, único ponto de foco';

  @override
  String get font => 'Fonte';

  @override
  String get forestTheme => 'Floresta';

  @override
  String get forestThemeDesc => 'Tema verde natural';

  @override
  String get forever => 'Para sempre';

  @override
  String get fortuneDisclaimer => 'Apenas para diversão.';

  @override
  String fortuneEggSemantic(int index) {
    return 'Ovo $index';
  }

  @override
  String get fortuneEggsSubtitle => 'Escolha um ovo abaixo';

  @override
  String get fortuneNoQuestion => 'Você não escreveu uma pergunta';

  @override
  String get fortunePlay => 'Ovos da Sorte';

  @override
  String get fortuneProceedToEggs => 'Ir para os Ovos';

  @override
  String get fortuneQuestionHint => 'Ex: Devo tentar algo novo esta semana?';

  @override
  String get fortuneQuestionPrompt => 'Digite a pergunta que está em sua mente';

  @override
  String get fortuneResultTitle => 'Sua resposta';

  @override
  String get fortuneSwipeInstruction =>
      'Deslize para a esquerda/direita para mudar o ovo, toque para revelar a resposta';

  @override
  String get fortuneTitle => 'Ovos da Sorte';

  @override
  String get freeTrial14Days => 'Teste grátis de 14 dias';

  @override
  String get frequency => 'Frequência';

  @override
  String get frequencyLabel => 'Frequência';

  @override
  String get fridayShort => 'Sex';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get fullScreen => 'Tela cheia';

  @override
  String get gallery => 'Galeria';

  @override
  String get gamesDescription =>
      'Dificuldade em decidir? Deixe jogos divertidos ajudarem você!';

  @override
  String get gamesTitle => 'Jogos';

  @override
  String get general => 'Geral';

  @override
  String get generalNotifications => 'Notificações gerais';

  @override
  String get generalRoomStatsHeader => 'ESTATÍSTICAS GERAIS DA SALA';

  @override
  String get generate => 'Gerar';

  @override
  String generatedAtDate(Object date) {
    return 'Gerado em: $date';
  }

  @override
  String get generating => 'Gerando...';

  @override
  String get glasses => 'Copos';

  @override
  String get goToPlayStore => 'Ir para a Play Store';

  @override
  String get goldenTheme => 'Dourado';

  @override
  String get goldenThemeDesc => 'Tema dourado quente';

  @override
  String get goodMorning => 'Bom dia! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Concedido';

  @override
  String get greatDayAhead => 'Hoje é um ótimo dia, você consegue!';

  @override
  String get greetingAfternoon => 'Boa tarde';

  @override
  String get greetingEvening => 'Boa noite';

  @override
  String get greetingMorning => 'Bom dia';

  @override
  String get guestAccount => 'Conta de Convidado';

  @override
  String get guidedJourney => 'Jornada Guiada';

  @override
  String get guidedJourneyDesc => 'Fluxo guiado passo a passo';

  @override
  String get habit => 'Hábito';

  @override
  String habitAddError(Object error) {
    return 'Erro ao adicionar hábitos: $error';
  }

  @override
  String habitAddSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hábitos adicionados',
      one: '1 hábito adicionado',
      zero: 'Nenhum hábito adicionado',
    );
    return '$_temp0';
  }

  @override
  String get habitBlock => 'Hábito';

  @override
  String habitCreatedMessage(Object title) {
    return 'Hábito criado: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Hábito excluído: $title';
  }

  @override
  String get habitDescription => 'Descrição';

  @override
  String get habitDescriptionHint => 'Adicione uma descrição curta...';

  @override
  String get habitDetails => 'Detalhes do Hábito';

  @override
  String get habitExplorerCreativeProject => 'Hora de Projeto Criativo';

  @override
  String get habitExplorerCreativeProjectDesc =>
      'Trabalhe em um projeto criativo que estimule sua imaginação.';

  @override
  String get habitExplorerExplorePlace => 'Explorar um Lugar Novo';

  @override
  String get habitExplorerExplorePlaceDesc =>
      'Visite um novo bairro, parque ou local em sua área.';

  @override
  String get habitExplorerLearnNewSkill => 'Aprender Algo Novo';

  @override
  String get habitExplorerLearnNewSkillDesc =>
      'Dedique um tempo a cada semana para aprender uma nova habilidade ou assunto.';

  @override
  String get habitExplorerReadDiverse => 'Ler Conteúdos Diversos';

  @override
  String get habitExplorerReadDiverseDesc =>
      'Leia livros, artigos ou conteúdos de diferentes gêneros e perspectivas.';

  @override
  String get habitExplorerTryNewActivity => 'Tentar uma Nova Atividade';

  @override
  String get habitExplorerTryNewActivityDesc =>
      'Saia da sua zona de conforto e experimente algo diferente.';

  @override
  String get habitMindfulBreathing => 'Exercício de Respiração Profunda';

  @override
  String get habitMindfulBreathingDesc =>
      'Pratique técnicas de respiração profunda para se centrar.';

  @override
  String get habitMindfulGratitude => 'Prática de Gratidão';

  @override
  String get habitMindfulGratitudeDesc =>
      'Escreva três coisas pelas quais você é grato hoje.';

  @override
  String get habitMindfulJournaling => 'Diário Reflexivo';

  @override
  String get habitMindfulJournalingDesc =>
      'Anote seus pensamentos e reflexões para o autoconhecimento.';

  @override
  String get habitMindfulMeditation => 'Meditação';

  @override
  String get habitMindfulMeditationDesc =>
      'Pratique meditação mindfulness por 10 a 15 minutos.';

  @override
  String get habitMindfulNatureWalk => 'Caminhada na Natureza';

  @override
  String get habitMindfulNatureWalkDesc =>
      'Faça uma caminhada consciente na natureza, prestando atenção ao seu redor.';

  @override
  String get habitName => 'Nome do Hábito';

  @override
  String get habitNameHint => 'Ex: Ler livro, Beber água...';

  @override
  String get habitNameHintNumerical => 'Ex: Beber água, Ler páginas...';

  @override
  String get habitNameHintTimer => 'Ex: Meditação, Exercício...';

  @override
  String get habitNamePlaceholder => 'Nome do Hábito';

  @override
  String get habitNotFound => 'Hábito não encontrado.';

  @override
  String get habitOfThisVision => 'Hábito desta visão';

  @override
  String get habitPlannerGoalSetting => 'Definição de Metas Mensais';

  @override
  String get habitPlannerGoalSettingDesc =>
      'Defina metas específicas e mensuráveis para o próximo mês.';

  @override
  String get habitPlannerMorningRoutine => 'Rotina Matinal';

  @override
  String get habitPlannerMorningRoutineDesc =>
      'Comece cada dia com uma rotina matinal estruturada para dar o tom à produtividade.';

  @override
  String get habitPlannerTaskPrioritization => 'Priorização de Tarefas Diárias';

  @override
  String get habitPlannerTaskPrioritizationDesc =>
      'Identifique suas 3 principais prioridades para o dia a cada manhã.';

  @override
  String get habitPlannerTimeBlocking => 'Bloqueio de Tempo';

  @override
  String get habitPlannerTimeBlockingDesc =>
      'Agende seu dia em blocos de tempo focados para um trabalho profundo.';

  @override
  String get habitPlannerWeeklyReview => 'Revisão Semanal';

  @override
  String get habitPlannerWeeklyReviewDesc =>
      'Toda semana revise seu progresso e planeje a próxima semana.';

  @override
  String get habitReminderBody => 'Hora de completar seu hábito!';

  @override
  String get habitReminders => 'Lembretes de Hábito';

  @override
  String get habitRemindersSubtitle => 'Lembretes diários para seus hábitos';

  @override
  String get habitSocialCallFriend => 'Ligar para um Amigo';

  @override
  String get habitSocialCallFriendDesc =>
      'Entre em contato com um amigo ou familiar para uma conversa significativa.';

  @override
  String get habitSocialCompliment => 'Fazer um Elogio Sincero';

  @override
  String get habitSocialComplimentDesc =>
      'Alegre o dia de alguém com um elogio genuíno.';

  @override
  String get habitSocialFamilyTime => 'Tempo de Qualidade em Família';

  @override
  String get habitSocialFamilyTimeDesc =>
      'Passe tempo dedicado com familiares sem distrações.';

  @override
  String get habitSocialGroupActivity => 'Participar de Atividade em Grupo';

  @override
  String get habitSocialGroupActivityDesc =>
      'Participe de uma atividade em grupo ou evento social.';

  @override
  String get habitSocialVolunteer => 'Voluntariado';

  @override
  String get habitSocialVolunteerDesc =>
      'Contribua com sua comunidade através de trabalho voluntário.';

  @override
  String get habitTypeLabel => 'Tipo de Hábito';

  @override
  String get habitTypePickerSubtitle => 'Que tipo de hábito você quer criar?';

  @override
  String get habitTypePickerTitle => 'Escolha o Tipo de Hábito';

  @override
  String get habitUpdatedMessage => 'Hábito atualizado.';

  @override
  String get habits => 'Hábitos';

  @override
  String get habitsSection => 'Hábitos';

  @override
  String get hard => 'Difícil';

  @override
  String get hardMode => 'Modo Difícil';

  @override
  String get headerFocusLabel => 'Foco';

  @override
  String get headerFocusReady => 'Pronto';

  @override
  String get headerHabitsLabel => 'Hábito';

  @override
  String get health => 'Saúde';

  @override
  String get helpAndSupport => 'Ajuda e Suporte';

  @override
  String get history => 'Histórico';

  @override
  String get historyTitle => 'Histórico';

  @override
  String get hourShort => 'h';

  @override
  String get hours => 'Horas';

  @override
  String get hoursSuffixShort => 'h';

  @override
  String get howAreYouFeeling => 'Como você está se sentindo?';

  @override
  String get howDoYouFeel => 'Como você se sente hoje?';

  @override
  String get howOftenDoHabit =>
      'Decida com que frequência você fará seu hábito';

  @override
  String get howToCancel => 'Como cancelar?';

  @override
  String get howToEarn => 'Como ganhar';

  @override
  String get howToTrackHabit => 'Escolha como seu hábito será rastreado';

  @override
  String get ifCondition => 'Se';

  @override
  String get ifTrialCancelled => 'E se o teste grátis for cancelado?';

  @override
  String get importFromLink => 'Importar do link';

  @override
  String get importantNotice => 'Aviso Importante';

  @override
  String get inactive => 'Inativo';

  @override
  String get incomeDelta => 'Delta de Renda';

  @override
  String get incomeEditTitle => 'Editar Renda';

  @override
  String get incomeLabel => 'Renda';

  @override
  String get incomeNewTitle => 'Nova Renda';

  @override
  String get incompleteSelectedDay => 'Incompleto (dia selecionado)';

  @override
  String get input => 'Entrada';

  @override
  String get insights => 'Percepções';

  @override
  String get insufficientTokensWatchAd =>
      'Tokens insuficientes! Assista a um anúncio para ganhar tokens.';

  @override
  String get invalidCodeLengthError => 'O código deve ter 6 caracteres';

  @override
  String get invalidLink => 'Link inválido.';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get inviteCodeCopiedSnackbar => 'Código de convite copiado!';

  @override
  String get inviteCodeTooltip => 'Código de Convite';

  @override
  String get issueDescription => 'Descrição do Problema';

  @override
  String get issueDescriptionHint => 'Descreva o problema em detalhes...';

  @override
  String get joinButton => 'Participar';

  @override
  String get joinRoomCodeMessage =>
      'Digite o código de convite de 6 dígitos enviado pelo seu amigo:';

  @override
  String get joinRoomSubtitle =>
      'Participe de uma sala existente com um código de convite';

  @override
  String joinRoomSuccessSnackbar(Object roomName) {
    return 'Você entrou na sala $roomName! 🎉';
  }

  @override
  String get joinRoomTitle => 'Participar da Sala';

  @override
  String joinedAtLabel(Object date) {
    return 'Entrou em: $date';
  }

  @override
  String get journalEntry => 'Entrada de Diário';

  @override
  String get journalEntryDesc =>
      'Há algo sobre o qual você gostaria de escrever hoje?';

  @override
  String get journalHint => 'Algo que você gostaria de escrever hoje...';

  @override
  String get jsonDataExample => 'Dados JSON (exemplo):';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String get keepItUp => 'Incrível! Continue assim! 💪';

  @override
  String get language => 'Idioma';

  @override
  String get languageSelection => 'Seleção de Idioma';

  @override
  String get last7DaysProgressLabel => 'Progresso dos Últimos 7 Dias';

  @override
  String lastBackup(String date) {
    return 'Último Backup: $date';
  }

  @override
  String get later => 'Mais tarde';

  @override
  String get lavenderDreams => 'Sonhos de Lavanda';

  @override
  String get lavenderDreamsDesc => 'Tons elegantes de lavanda e roxo';

  @override
  String get leaderboardDetailsTitle => 'Detalhes do ranking';

  @override
  String get leaveButton => 'Sair';

  @override
  String get leaveRoomTitle => 'Sair da Sala';

  @override
  String get leaveRoomWarning => 'Tem certeza de que deseja sair desta sala?';

  @override
  String get letsPlayGame => 'Vamos jogar! 🎮';

  @override
  String get letsStart => 'Vamos Começar';

  @override
  String levelLabel(Object level) {
    return 'Nível $level';
  }

  @override
  String levelShort(Object level) {
    return 'N$level';
  }

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get likertAgree => 'Concordo';

  @override
  String get likertDisagree => 'Discordo';

  @override
  String get likertNeutral => 'Neutro';

  @override
  String get likertStronglyAgree => 'Concordo plenamente';

  @override
  String get likertStronglyDisagree => 'Discordo plenamente';

  @override
  String get linkHabits => 'Vincular hábitos';

  @override
  String listCreated(Object title) {
    return 'Lista criada: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'Lista criada com sucesso';
  }

  @override
  String get listLabel => 'Lista';

  @override
  String get listNameHint => 'Digite o nome da lista';

  @override
  String get listNameLabel => 'Nome da Lista';

  @override
  String get loadingHabits => 'Carregando hábitos...';

  @override
  String get logout => 'Sair';

  @override
  String get longestStreak => 'Maior Sequência';

  @override
  String get longestStreakLabel => 'Maior Sequência';

  @override
  String get manageLists => 'Gerenciar listas';

  @override
  String get manageListsSubtitle => 'Organize seus hábitos e tarefas';

  @override
  String get manageOnGooglePlay => 'Gerenciar na Google Play';

  @override
  String get manageSubscription => 'Gerenciar Assinatura';

  @override
  String get manageSubscriptionDesc =>
      'Mudar plano, cancelar ou ver detalhes de cobrança';

  @override
  String get manageSubscriptionSubtitle =>
      'Gerenciar assinatura Mira Plus via Google Play';

  @override
  String get manageVisionTasks => 'Gerenciar Tarefas';

  @override
  String get manualFallback => 'Criar Manualmente';

  @override
  String get maxOptionsReached => 'Máximo de 12 opções permitidas';

  @override
  String get meditation => 'Meditação';

  @override
  String get medium => 'Médio';

  @override
  String memberCountText(Object count) {
    return '$count membros';
  }

  @override
  String get memberHabitsLabel => 'Hábitos do Membro';

  @override
  String get memberProfileTitle => 'Perfil do Membro';

  @override
  String get memberTableHeader => 'MEMBRO';

  @override
  String membersCompletedStatus(Object completed, Object total) {
    return '$completed/$total membros concluíram';
  }

  @override
  String membersCountText(Object count) {
    return '$count pessoas';
  }

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'Atenção Plena';

  @override
  String get mintFresh => 'Menta Fresca';

  @override
  String get mintFreshDesc => 'Tons de menta fresca e turquesa';

  @override
  String get minutes => 'Minutos';

  @override
  String get minutesSuffixShort => 'min';

  @override
  String get miraPlusActive => 'Mira Plus Ativo';

  @override
  String get miraPlusInactive => 'Mira Plus Inativo';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Seg';

  @override
  String get monthCount => 'Contagem de meses';

  @override
  String get monthCountHint => 'Ex: 12';

  @override
  String get monthSuffixShort => 'mês';

  @override
  String get monthly => 'Mensal';

  @override
  String monthlyDays(Object days) {
    return 'Dias $days do mês';
  }

  @override
  String get monthlyDesc => 'Em dias específicos do mês';

  @override
  String get monthlyProgress => 'Progresso mensal';

  @override
  String get monthlyTrend => 'Tendência mensal';

  @override
  String get monthsShort => 'Jan,Fev,Mar,Abr,Mai,Jun,Jul,Ago,Set,Out,Nov,Dez';

  @override
  String get mood => 'Humor';

  @override
  String get moodAnalytics => 'Análise de Humor';

  @override
  String get moodBad => 'Ruim';

  @override
  String get moodBadDesc => 'Estou passando por um momento difícil';

  @override
  String get moodDeclining => 'Seu humor parece estar caindo';

  @override
  String get moodDistribution => 'Distribuição de Humor';

  @override
  String get moodExcellent => 'Excelente';

  @override
  String get moodExcellentDesc => 'Estou me sentindo excelente';

  @override
  String get moodFlow => 'Humor';

  @override
  String get moodFlowSubtitle => 'Selecione seu humor hoje';

  @override
  String get moodFlowTitle => 'Como Você Está se Sentindo?';

  @override
  String get moodGood => 'Bom';

  @override
  String get moodGoodDesc => 'Estou me sentindo positivo';

  @override
  String get moodGreat => 'Ótimo';

  @override
  String get moodImproving => 'Seu humor está melhorando!';

  @override
  String get moodNeutral => 'Neutro';

  @override
  String get moodNeutralDesc => 'Estou me sentindo normal';

  @override
  String get moodOk => 'Normal';

  @override
  String get moodSelection => 'Seleção de Humor';

  @override
  String get moodStable => 'Seu humor está relativamente estável';

  @override
  String get moodTerrible => 'Terrível';

  @override
  String get moodTerribleDesc => 'Estou me sentindo muito mal';

  @override
  String get moodTracker => 'Rastreador de Humor';

  @override
  String get moodTrend => 'Tendência de Humor (Últimos 30 Dias)';

  @override
  String get moreChartsButton => 'Mais Gráficos';

  @override
  String get mostActiveMemberLabel => 'Membro mais ativo';

  @override
  String get mostCommonEmotion => 'Emoção Mais Comum';

  @override
  String get mostCommonMood => 'Humor Mais Comum';

  @override
  String get mostCommonReason => 'Motivo Mais Comum';

  @override
  String get motivation => 'Motivação';

  @override
  String motivationBody(Object percent, Object period) {
    return 'Ótimo! Você alcançou uma taxa de sucesso de $percent% em $period.';
  }

  @override
  String motivationDayStart(Object title) {
    return 'Ótimo dia para $title! 🌟';
  }

  @override
  String get motivationJourneyStart =>
      'Toda jornada começa com um único passo!';

  @override
  String get motivationSmallSteps =>
      'Comece com pequenos passos para atingir grandes metas 💪';

  @override
  String motivationWaiting(Object title) {
    return '$title está esperando por você 🚀';
  }

  @override
  String get mtdAverageShort => 'Média MTD';

  @override
  String get multiple => 'Múltiplo';

  @override
  String get multipleSubItems => 'Múltiplos sub-itens';

  @override
  String get multipleSubItemsDesc => 'Múltiplos sub-itens';

  @override
  String get mustBePremiumToUse =>
      'Você deve ser um assinante Premium para usar este recurso.';

  @override
  String get myBigGoal => 'Minha Grande Meta';

  @override
  String get myBoard => 'Meu Mural';

  @override
  String get mysticTheme => 'Místico';

  @override
  String get mysticThemeDesc => 'Tema roxo místico';

  @override
  String nDays(Object days) {
    return '$days dias';
  }

  @override
  String nDaysLabel(Object count) {
    return '$count dias';
  }

  @override
  String get nameHint => 'Ex: Treino diário';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nameRequired => 'O nome é obrigatório';

  @override
  String get nameYourVision => 'Dê um Nome à Sua Visão';

  @override
  String get nameYourVisionDesc => 'Dê à sua visão um nome significativo';

  @override
  String get nameYourVisionSubtitle => 'Dê à sua visão um nome significativo';

  @override
  String get needAtLeastTwoOptions => 'Necessário pelo menos 2 opções';

  @override
  String get newCategory => 'Nova categoria';

  @override
  String get newHabit => 'Novo Hábito';

  @override
  String get newHabits => 'Novos hábitos';

  @override
  String get newList => 'Nova Lista';

  @override
  String get next => 'Próximo';

  @override
  String get nextLabel => 'Próximo';

  @override
  String get nextWeek => 'Próxima Semana';

  @override
  String get nextYear => 'Próximo ano';

  @override
  String get noActiveHabitsForMember =>
      'O membro ainda não possui hábitos ativos.';

  @override
  String get noBackups => 'Nenhum backup encontrado';

  @override
  String get noBackupsFound => 'Nenhum backup encontrado.';

  @override
  String get noBadgesEarned => 'Nenhum emblema ganho ainda.';

  @override
  String get noDataLast7Days => 'Sem dados nos últimos 7 dias';

  @override
  String get noDataThisMonth => 'Sem dados para este mês';

  @override
  String get noEndDate => 'Sem data de término';

  @override
  String get noEndDayDefaultsDaily =>
      'Quando nenhum dia final é definido, este hábito aparecerá todos os dias por padrão.';

  @override
  String get noEntriesYet => 'Nenhuma entrada ainda';

  @override
  String get noEvents => 'Nenhum evento ainda';

  @override
  String get noExpenseInThisCategory => 'Sem despesas nesta categoria';

  @override
  String get noExpenses => 'Sem despesas';

  @override
  String get noExpensesThisMonth => 'Sem despesas para este mês';

  @override
  String get noHabitsAdded => 'Nenhum hábito adicionado';

  @override
  String get noHabitsAddedYet => 'Nenhum hábito adicionado ainda.';

  @override
  String get noHabitsInRoom => 'Nenhum hábito adicionado ainda';

  @override
  String get noHistory => 'Sem histórico de humor';

  @override
  String get noIncomeThisMonth => 'Sem renda para este mês';

  @override
  String get noItemsMatchFilters =>
      'Nenhum item corresponde aos filtros atuais';

  @override
  String get noLeaderboardData => 'Sem Dados de Ranking';

  @override
  String get noLinkedHabitsInVision => 'Nenhum hábito vinculado a esta visão.';

  @override
  String get noMeasurableDataForMember =>
      'Nenhum dado mensurável disponível para este membro ainda.';

  @override
  String get noMemberDataYet => 'Sem dados de membros ainda.';

  @override
  String get noMoodData => 'Sem dados de humor ainda';

  @override
  String get noNotesYet => 'Nenhuma nota ainda';

  @override
  String get noPlansAvailable => 'Nenhum plano disponível no momento.';

  @override
  String get noProgressYet => 'Sem progresso ainda';

  @override
  String get noReadyVisionsFound => 'Nenhuma visão pronta encontrada.';

  @override
  String get noRecordsThisMonth => 'Sem registros para este mês';

  @override
  String get noReportsYet => 'Nenhum relatório ainda';

  @override
  String get noRoomsJoinedMessage =>
      'Crie uma sala ou entre em uma com um código.\nAtinja metas junto com seus amigos!';

  @override
  String get noRoomsJoinedTitle => 'Você ainda não entrou em nenhuma sala';

  @override
  String get noStatsAvailable => 'Estatísticas Indisponíveis';

  @override
  String get noTasksYet => 'Nenhuma tarefa adicionada ainda';

  @override
  String get noTrendData => 'Dados insuficientes para tendências';

  @override
  String get notAddedYet => 'Ainda não adicionado.';

  @override
  String get notGranted => 'Não Concedido';

  @override
  String get notSelected => 'Não selecionado';

  @override
  String get notUnlocked => 'Não desbloqueado';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get noteSharedSnackbar => 'Nota compartilhada! ✨';

  @override
  String get notesSection => '📝 Notas';

  @override
  String get notificationBehavior => 'Comportamento das Notificações';

  @override
  String get notificationPermission => 'Permissão de Notificação';

  @override
  String get notificationSettings => 'Configurações de notificação';

  @override
  String get notificationSettingsSubtitle =>
      'Configure suas preferências de notificação';

  @override
  String get notificationTroubleshooting =>
      'Para que as notificações funcionem corretamente:\n\n• Desative a otimização de bateria (Configurações → Apps → Mira → Bateria → Sem restrições)\n• Permita a atividade em segundo plano\n• Certifique-se de que as permissões de notificação estão ATIVADAS\n• Verifique o modo \'Não Perturbe\'';

  @override
  String get notificationTypes => 'Tipos de Notificação';

  @override
  String get notifications => 'Notificações';

  @override
  String get notificationsMasterSubtitle =>
      'Controlar todas as notificações do app';

  @override
  String get nudgeButtonLabel => 'Toque';

  @override
  String get nudgeDefaultMessage =>
      '👊 Vamos lá amigo, um pouco mais de esforço hoje! Complete seus hábitos.';

  @override
  String nudgeNotification(Object name) {
    return '👊 $name está te dando um toque!';
  }

  @override
  String nudgeSuccessSnackbar(Object displayName) {
    return '$displayName recebeu um toque! 👊';
  }

  @override
  String nudgeTitle(Object displayName) {
    return 'Dar um toque em $displayName 👊';
  }

  @override
  String get numberLabel => 'Número';

  @override
  String get numericExample => 'Beba 8 copos de água por dia';

  @override
  String get numericSettings => 'Configurações de Meta Numérica';

  @override
  String get numericTypeDesc => 'Rastreio de números';

  @override
  String get numericalDescription => 'Rastreio de meta numérica';

  @override
  String get numericalGoalShort => 'Meta numérica';

  @override
  String get numericalType => 'Valor Numérico';

  @override
  String get oceanTheme => 'Oceano';

  @override
  String get oceanThemeDesc => 'Tema azul calmo';

  @override
  String get off => 'Desligado';

  @override
  String get offLabel => 'Desligado';

  @override
  String get ok => 'OK';

  @override
  String get onDailyLimit => 'Você está no seu limite diário.';

  @override
  String get onPeriodic => 'Em intervalos específicos';

  @override
  String get onSpecificMonthDays => 'Em dias específicos do mês';

  @override
  String get onSpecificWeekdays => 'Em dias específicos da semana';

  @override
  String get onSpecificYearDays => 'Em dias específicos do ano';

  @override
  String get onboardingQ1 =>
      'Gosto de experimentar novas experiências e explorar coisas desconhecidas.';

  @override
  String get onboardingQ10 =>
      'Planejo com antecedência eventos e tarefas importantes.';

  @override
  String get onboardingQ11 =>
      'Gosto de tentar abordagens diferentes em vez de seguir um único método.';

  @override
  String get onboardingQ12 =>
      'Mantenho a calma sob pressão e me recupero rapidamente de contratempos.';

  @override
  String get onboardingQ2 =>
      'Mantenho meu espaço organizado e prefiro ter uma rotina diária estruturada.';

  @override
  String get onboardingQ3 =>
      'Sinto-me energizado quando estou perto de outras pessoas e gosto de encontros sociais.';

  @override
  String get onboardingQ4 =>
      'Prefiro trabalhar com outras pessoas e acho que a cooperação é mais eficaz do que a competição.';

  @override
  String get onboardingQ5 =>
      'Lido com situações estressantes com calma e raramente me sinto ansioso.';

  @override
  String get onboardingQ6 =>
      'Gosto de atividades criativas como arte, música ou escrita.';

  @override
  String get onboardingQ7 =>
      'Estabeleço metas claras para mim mesmo e trabalho diligentemente para alcançá-las.';

  @override
  String get onboardingQ8 =>
      'Prefiro atividades em grupo do que passar tempo sozinho.';

  @override
  String get onboardingQ9 =>
      'Muitas vezes considero os sentimentos dos outros antes de tomar decisões.';

  @override
  String get onboardingQuizIntro =>
      'Responda a algumas perguntas para nos ajudar a entender melhor sua personalidade. Isso é baseado em pesquisas psicológicas validadas cientificamente.';

  @override
  String get onboardingWelcomeDesc =>
      'Seu rastreador de hábitos pessoal que cresce com você. Vamos descobrir sua personalidade única e sugerir hábitos sob medida para você.';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao Mira';

  @override
  String get once => 'Uma vez';

  @override
  String get open => 'Abrir';

  @override
  String get openBatteryOptimization => 'Abrir otimização de bateria';

  @override
  String get openNotificationSettings => 'Abrir configurações de notificação';

  @override
  String get openSystemSettings => 'Abrir configurações do sistema';

  @override
  String get option1 => 'Opção 1';

  @override
  String get option2 => 'Opção 2';

  @override
  String get optional => 'opcional';

  @override
  String get optionalLabel => 'opcional';

  @override
  String get other => 'Outro';

  @override
  String get outline => 'Contorno';

  @override
  String get outlineColor => 'Cor do contorno';

  @override
  String get overall => 'Geral';

  @override
  String get overallProgress => 'Progresso geral';

  @override
  String get overview => 'Visão geral';

  @override
  String get pages => 'Páginas';

  @override
  String get pastelColors => 'Cores Pastel';

  @override
  String get pause => 'Pausar';

  @override
  String get perMonth => '/mês';

  @override
  String get perYear => '/ano';

  @override
  String get periodic => 'Periódico';

  @override
  String get periodicDesc => 'Em intervalos regulares';

  @override
  String get periodicSelection => 'Seleção Periódica';

  @override
  String get personalizedInsights => 'Percepções Personalizadas';

  @override
  String get photo => 'Foto';

  @override
  String get pickFromCalendar => 'Escolher do Calendário';

  @override
  String get pickTime => 'Escolher Hora';

  @override
  String get pickTodaysMood => 'Escolha o humor de hoje';

  @override
  String get plannedMonthlySpend => 'Gasto mensal planejado';

  @override
  String plansLoadError(Object error) {
    return 'Erro ao carregar planos: $error';
  }

  @override
  String get plateColor => 'Cor da placa';

  @override
  String get playAgain => 'Jogar Novamente';

  @override
  String get pleaseEnterEmail => 'Por favor, insira o e-mail';

  @override
  String get pleaseFillAllFields => 'Por favor, preencha todos os campos';

  @override
  String get pointsTableHeader => 'PONTOS';

  @override
  String get pomodoroAndCustomTimers =>
      'Pomodoro e temporizadores personalizados';

  @override
  String get premiumBenefits => 'Benefícios Premium:';

  @override
  String get premiumFeature => 'Recurso Premium';

  @override
  String get premiumFeatureLabel => 'Recurso Premium';

  @override
  String get premiumFeatures => 'Recursos Premium';

  @override
  String get premiumPlans => 'Planos Premium';

  @override
  String get previous => 'Anterior';

  @override
  String get previousYear => 'Ano anterior';

  @override
  String get prioritizeTaskSubtitle => 'Priorizar esta tarefa';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get privacyPolicyTitle => 'Política de Privacidade';

  @override
  String get privacySecurity => 'Privacidade e segurança';

  @override
  String get privacySecuritySubtitle =>
      'Gerenciar configurações e opções de exclusão de dados';

  @override
  String get processingWait => 'Processando, por favor aguarde...';

  @override
  String get productivity => 'Produtividade';

  @override
  String get profile => 'Perfil';

  @override
  String get profileInfo => 'Informações do perfil';

  @override
  String get profileUpdated => 'Perfil atualizado';

  @override
  String get progressJourneyMessage =>
      'À medida que você conclui seus hábitos, este gráfico será moldado pelo seu sucesso ✨';

  @override
  String get progressJourneyStarts => 'Jornada do Progresso Começa';

  @override
  String get promoCodeActiveMessage =>
      'Seu acesso Premium foi ativado via código promocional ✨';

  @override
  String get promoCodeAlreadyUsed =>
      'Um código promocional já foi usado nesta conta.';

  @override
  String get promoCodeHint => 'Insira seu código promocional';

  @override
  String get promoCodeInvalid =>
      'Código promocional inválido. Verifique e tente novamente.';

  @override
  String get promoCodeLabel => 'Código Promocional';

  @override
  String get promoCodeSuccess =>
      '🎉 Código promocional aplicado com sucesso! Acesso Premium ativado.';

  @override
  String get quickSuggestions => 'Sugestões Rápidas';

  @override
  String get rankingAndHabitsSection => '🏆 Ranking e Hábitos';

  @override
  String get readBook => 'Ler Livro';

  @override
  String get readyVisionsLoadFailed =>
      'Não foi possível carregar visões prontas.';

  @override
  String get reasonAcademic => 'Acadêmico';

  @override
  String get reasonFinance => 'Finanças';

  @override
  String get reasonHealth => 'Saúde';

  @override
  String get reasonOther => 'Outro';

  @override
  String get reasonPersonalGrowth => 'Crescimento Pessoal';

  @override
  String get reasonRelationship => 'Relacionamento';

  @override
  String get reasonSelection => 'Qual é o motivo deste estado?';

  @override
  String get reasonSocial => 'Social';

  @override
  String get reasonTitle => 'Motivo';

  @override
  String get reasonWeather => 'Clima';

  @override
  String get reasonWork => 'Trabalho';

  @override
  String get recommendedHabits => 'Hábitos Recomendados para Você';

  @override
  String get recurringMonthlyDesc =>
      'Adicionar automaticamente todo mês na data selecionada';

  @override
  String get recurringMonthlyTitle => 'Recorrente (mensal)';

  @override
  String get refreshList => 'Atualizar Lista';

  @override
  String get refundPolicy =>
      'Pedidos de reembolso estão sujeitos às políticas da Google Play. Você pode solicitar via Play Store.';

  @override
  String get reload => 'Recarregar';

  @override
  String get remainingToday => 'Restante hoje';

  @override
  String get reminder => 'Lembrete';

  @override
  String get reminderDisabled => 'Lembrete Desligado';

  @override
  String get reminderEnabled => 'Lembrete Ligado';

  @override
  String get reminderFrequency => 'Frequência de Lembrete';

  @override
  String get reminderLabel => 'Lembrete';

  @override
  String get reminderSettings => 'Configurações de Lembrete';

  @override
  String get reminderTime => 'Hora do Lembrete';

  @override
  String get removeFromList => 'Remover da lista';

  @override
  String get repeatEveryDay => 'Repete todos os dias';

  @override
  String repeatEveryNDays(Object days) {
    return 'Repetir a cada N dias';
  }

  @override
  String get reportAlreadyExists => 'Já existe um relatório para esta semana.';

  @override
  String get reportBug => 'Relatar Bug';

  @override
  String get reportBugDescription =>
      'Descreva o problema que você encontrou em detalhes abaixo.';

  @override
  String get reportBugSubtitle => 'Relate problemas que você encontrar';

  @override
  String get reportCreatedSuccess => 'Relatório criado! ✨';

  @override
  String get reset => 'Redefinir';

  @override
  String get resetAction => 'Redefinir';

  @override
  String get resetOnboarding => 'Redefinir Introdução';

  @override
  String get resetOnboardingDescription =>
      'Isso limpará seus resultados atuais de personalidade e permitirá que você refaça o teste.';

  @override
  String get resetOnboardingTitle => 'Redefinir Introdução?';

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreError => 'Erro de Restauração';

  @override
  String get restoreFailed => 'Restauração falhou';

  @override
  String get restoreLatest => 'Restaurar Mais Recente';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String restoreSuccess(Object content) {
    return 'Baixado: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Seus dados foram restaurados com sucesso. Recomendamos reiniciar o app para que as mudanças tenham efeito completo.';

  @override
  String get retakePersonalityTest => 'Refazer Teste de Personalidade';

  @override
  String get retakePersonalityTestDesc => 'Redescubra seu tipo de personagem';

  @override
  String get retakeRhythmTest => 'Refazer Teste de Ritmo';

  @override
  String get retakeRhythmTestDesc => 'Reconfigure seu relógio biológico';

  @override
  String get retry => 'Repetir';

  @override
  String get rhythmA1_1 => '22:00 – 23:00';

  @override
  String get rhythmA1_2 => '23:00 – 00:00';

  @override
  String get rhythmA1_3 => '00:00 – 01:00';

  @override
  String get rhythmA1_4 => '01:00+';

  @override
  String get rhythmA1_5 => '11:00 – 12:00';

  @override
  String get rhythmA2_1 => '06:00 – 07:00';

  @override
  String get rhythmA2_2 => '07:00 – 08:00';

  @override
  String get rhythmA2_3 => '08:00 – 09:00';

  @override
  String get rhythmA2_4 => '09:00+';

  @override
  String get rhythmA3_1 => 'Início da manhã';

  @override
  String get rhythmA3_2 => 'Meio da manhã';

  @override
  String get rhythmA3_3 => 'Tarde';

  @override
  String get rhythmA3_4 => 'Noite';

  @override
  String get rhythmA3_5 => 'Sem diferença';

  @override
  String get rhythmA4_1 => 'Manhã';

  @override
  String get rhythmA4_2 => 'Meio-dia';

  @override
  String get rhythmA4_3 => 'Tarde';

  @override
  String get rhythmA4_4 => 'Noite';

  @override
  String get rhythmA4_5 => 'Varia';

  @override
  String get rhythmA5_1 => 'Manhã';

  @override
  String get rhythmA5_2 => 'Meio-dia';

  @override
  String get rhythmA5_3 => 'Tarde';

  @override
  String get rhythmA5_4 => 'Nenhum';

  @override
  String get rhythmAnalyzing => 'O Ritmo Vivo está analisando...';

  @override
  String get rhythmBenefit1 => 'Tarefa certa na hora certa';

  @override
  String get rhythmBenefit2 => 'Sem fadiga de decisão';

  @override
  String get rhythmBenefit3 => 'Personalização toda semana';

  @override
  String get rhythmChronoEvening => 'Tipo Vespertino (Coruja)';

  @override
  String get rhythmChronoIntermediate => 'Tipo Intermediário (Equilibrado)';

  @override
  String get rhythmChronoMorning => 'Tipo Matutino (Cotovia)';

  @override
  String get rhythmDisclaimer =>
      'Estes não são resultados definitivos. O Ritmo Vivo se ajustará à medida que conhecer você.';

  @override
  String get rhythmEnergyHint => 'Treino, atividade física';

  @override
  String get rhythmFocusHint => 'Trabalho mental, análise, aprendizado';

  @override
  String get rhythmHabitSuggestionTitle => 'Blocos de Horário Recomendados:';

  @override
  String get rhythmLightHint => 'E-mails, redes sociais, pequenas tarefas';

  @override
  String get rhythmQ1 => 'A que horas você costuma ir dormir?';

  @override
  String get rhythmQ2 => 'A que horas você costuma acordar?';

  @override
  String get rhythmQ3 =>
      'Quando você lida com tarefas difíceis com mais conforto?';

  @override
  String get rhythmQ4 =>
      'Em que hora do dia você se sente melhor (mais enérgico)?';

  @override
  String get rhythmQ5 =>
      'Você se considera um \'tipo matutino\' ou um \'tipo vespertino\'?';

  @override
  String get rhythmReflectionHint => 'Diário, leitura, relaxamento';

  @override
  String get rhythmResultGotIt => 'Entendido, Vamos Começar';

  @override
  String get rhythmResultSubtitle =>
      'Mapeamos o seu dia com base no seu ritmo natural.';

  @override
  String get rhythmResultTitle => 'Seu Perfil de Relógio Biológico';

  @override
  String get rhythmTeaserCta => 'Ver Pacotes';

  @override
  String get rhythmTeaserSkip => 'Pular';

  @override
  String get rhythmTeaserSubtitle =>
      'O Ritmo Vivo aprende seus momentos mais produtivos e coloca hábitos na hora certa.';

  @override
  String get rhythmTeaserTitle =>
      'Maximize Seus Hábitos com Base no Seu Relógio Biológico';

  @override
  String get rhythmWindowEnergy => 'Hora da Energia';

  @override
  String get rhythmWindowEnergyDesc => 'Movimento, ação, esportes';

  @override
  String get rhythmWindowFocus => 'Hora do Foco';

  @override
  String get rhythmWindowFocusDesc => 'Clareza mental, aprendizado, análise';

  @override
  String get rhythmWindowLight => 'Hora Leve';

  @override
  String get rhythmWindowLightDesc => 'Baixo esforço, pequenas tarefas';

  @override
  String get rhythmWindowNoProfileHint =>
      'Complete o teste de ritmo para receber sugestões personalizadas';

  @override
  String get rhythmWindowReflection => 'Hora da Reflexão';

  @override
  String get rhythmWindowReflectionDesc => 'Diário, contemplação, encerramento';

  @override
  String get rhythmWindowStepSubtitle =>
      'Em qual janela de tempo você gostaria de fazer este hábito?';

  @override
  String get rhythmWindowStepTitle => 'Melhor Janela de Tempo';

  @override
  String get roomFabLabel => 'Sala';

  @override
  String get roomMembersLabel => 'MEMBROS DA SALA';

  @override
  String get roomNameHint => 'ex: Equipe de Rotina Matinal';

  @override
  String get roomNameLabel => 'Nome da Sala';

  @override
  String get roomNotFoundError => 'Nenhuma sala encontrada com este código';

  @override
  String get roomSummaryHeader => 'RESUMO DA SALA';

  @override
  String get roundCorners => 'Cantos arredondados';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Regra: Duração inserida ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Regra: Duração inserida ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Regra: Duração inserida = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Regra: Valor inserido ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Regra: Valor inserido ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Regra: Valor inserido = $target';
  }

  @override
  String get runningLabel => 'EXECUTANDO';

  @override
  String get saturdayShort => 'Sáb';

  @override
  String get save => 'Salvar';

  @override
  String get saveButton => 'Salvar';

  @override
  String get saveChanges => 'Salvar Alterações';

  @override
  String get saveEntry => 'Salvar Entrada';

  @override
  String get saveError => 'Ocorreu um erro ao salvar';

  @override
  String get saved => 'Salvo';

  @override
  String get saving => 'Salvando...';

  @override
  String get savingsBudgetPlan => 'Poupança / Plano de Orçamento';

  @override
  String get scheduleHabit => 'Defina o cronograma do seu hábito';

  @override
  String get scheduleLabel => 'Cronograma';

  @override
  String get schedulingOptions => 'Opções de Agendamento';

  @override
  String get seconds => 'Segundos';

  @override
  String get seeFullSubscriptionInfo =>
      'Ver informações completas da assinatura';

  @override
  String get select => 'Selecionar';

  @override
  String get selectAll => 'Selecionar Tudo';

  @override
  String get selectAtLeastOneDay => 'Por favor, selecione pelo menos um dia';

  @override
  String get selectCategory => 'Selecionar Categoria';

  @override
  String get selectDate => 'Selecionar Data';

  @override
  String get selectDay => 'Selecionar Dia';

  @override
  String get selectDuration => 'Selecionar Duração';

  @override
  String get selectEmoji => 'Selecionar Emoji';

  @override
  String get selectEndDate => 'Selecionar data de término';

  @override
  String get selectFrequency => 'Selecionar Frequência';

  @override
  String get selectHabitLabel => 'Selecionar Hábito';

  @override
  String get selectHabitType => 'Selecionar Tipo de Hábito';

  @override
  String get selectHabitsToAdd =>
      'Selecione hábitos que você gostaria de adicionar à sua rotina diária:';

  @override
  String get selectMonthTooltip => 'Selecionar mês';

  @override
  String get selectReason => 'Selecionar Motivo';

  @override
  String get selectReasonDesc => 'Qual fator mais afetou o seu dia?';

  @override
  String get selectReportType => 'Selecionar Tipo de Relatório:';

  @override
  String get selectSubEmotion => 'Selecionar Sub-emoção';

  @override
  String get selectSubEmotionDesc => 'Qual sub-emoção melhor descreve você?';

  @override
  String get selectTime => 'Selecionar Hora';

  @override
  String get selectYourCurrentMood => 'Selecione seu humor atual';

  @override
  String get selectYourMood => 'Selecione seu humor';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Dias $sorted do mês';
  }

  @override
  String get send => 'Enviar';

  @override
  String get sendBackward => 'Enviar para trás';

  @override
  String get setAsTodayFocus => 'Definir como Foco de Hoje';

  @override
  String get setVisionTimeline => 'Defina a linha do tempo para sua visão';

  @override
  String get settings => 'Configurações';

  @override
  String get shareAsLink => 'Compartilhar como link';

  @override
  String get shareBoard => 'Compartilhar mural';

  @override
  String get shareButton => 'Compartilhar';

  @override
  String get shareDashboard => 'Compartilhar Painel';

  @override
  String get shareInviteCodeMessage =>
      'Compartilhe este código com seus amigos:';

  @override
  String get shareLinkCopied =>
      'Link de compartilhamento copiado para a área de transferência.';

  @override
  String get shareNoteHint => 'Compartilhe seus pensamentos...';

  @override
  String get shareNoteTitle => 'Compartilhar Nota';

  @override
  String get shareNoteTooltip => 'Compartilhar Nota';

  @override
  String get shareVision => 'Compartilhar visão';

  @override
  String get showProgress => 'Mostrar progresso';

  @override
  String get showText => 'Mostrar texto';

  @override
  String get shuffle => 'Embaralhar';

  @override
  String get signInFailed => 'Falha ao entrar. Por favor, tente novamente.';

  @override
  String get signInToSaveData => 'Entre para salvar os dados';

  @override
  String get signInWithGoogle => 'Entrar com Google';

  @override
  String get signInWithGoogleButton => 'Entrar com Google';

  @override
  String get signInWithGoogleDesc =>
      'Conecte sua conta do Google para continuar. Suas informações de perfil serão preenchidas automaticamente.';

  @override
  String get signInWithGoogleTitle => 'Entre com sua conta do Google';

  @override
  String get signOut => 'Sair';

  @override
  String get signOutConfirmation => 'Tem certeza de que deseja sair?';

  @override
  String get simpleHabitColorSubtitle =>
      'Reflita a personalidade do seu hábito';

  @override
  String get simpleHabitColorTitle => 'Escolha uma cor';

  @override
  String get simpleHabitEmojiSubtitle => 'Deixe seu hábito mais divertido!';

  @override
  String get simpleHabitEmojiTitle => 'Escolha um emoji para representá-lo';

  @override
  String get simpleHabitFrequencySubtitle => 'Defina suas metas';

  @override
  String get simpleHabitFrequencyTitle => 'Com que frequência você quer fazer?';

  @override
  String get simpleHabitMonthDaysSubtitle => 'Selecione os dias ativos';

  @override
  String get simpleHabitMonthDaysTitle => 'Em quais dias do mês?';

  @override
  String get simpleHabitNameSubtitle => 'O que você quer tornar um hábito?';

  @override
  String get simpleHabitNameTitle => 'Dê um nome ao seu hábito';

  @override
  String get simpleHabitPeriodicSubtitle => 'Defina o intervalo de repetição';

  @override
  String get simpleHabitPeriodicTitle => 'A cada quantos dias?';

  @override
  String get simpleHabitPreviewSubtitle => 'Tudo parece correto?';

  @override
  String get simpleHabitPreviewTitle => 'Incrível! Aqui está seu hábito';

  @override
  String get simpleHabitReminderSubtitle =>
      'Não perca seu hábito com lembretes diários';

  @override
  String get simpleHabitReminderTitle => 'Devo te lembrar?';

  @override
  String get simpleHabitStartDateSubtitle =>
      'Escolha um ponto de partida para sua jornada';

  @override
  String get simpleHabitStartDateTitle => 'Quando você vai começar?';

  @override
  String get simpleHabitSubtitle => 'Crie um hábito rapidamente';

  @override
  String get simpleHabitTargetOne => 'Hábito simples (meta = 1)';

  @override
  String get simpleHabitTitle => 'Hábito Simples';

  @override
  String get simpleHabitTypeDescription =>
      'Para verificações diárias. Concluído ou ignorado.';

  @override
  String get simpleHabitWeekdaysSubtitle => 'Selecione os dias ativos';

  @override
  String get simpleHabitWeekdaysTitle => 'Quais dias?';

  @override
  String get simpleHabitWizardDesc =>
      'Vou te guiar passo a passo. Vamos criar um hábito incrível juntos!';

  @override
  String get simpleHabitWizardTitle => 'Pronto para adquirir um novo hábito?';

  @override
  String get simpleTypeShort => 'Simples';

  @override
  String get skip => 'Pular';

  @override
  String get skipOnboarding => 'Pular';

  @override
  String get skipTest => 'Pular Teste';

  @override
  String get social => 'Social';

  @override
  String get socialFeaturesGuestMessage =>
      'Você precisa entrar com o Google para criar salas e acompanhar o progresso com amigos.';

  @override
  String get socialFeaturesTitle => 'Recursos Sociais';

  @override
  String get socialFeedTitle => 'Feed';

  @override
  String get socialRoomsTitle => 'Salas Sociais';

  @override
  String get softCloud => 'Nuvem Suave';

  @override
  String get softCloudDesc => 'Como uma nuvem, suave e sonhadora';

  @override
  String get softPeach => 'Pêssego Suave';

  @override
  String get softPeachDesc => 'Tons quentes de pêssego e creme';

  @override
  String get sound => 'Som';

  @override
  String get soundAlerts => 'Alertas sonoros';

  @override
  String get soundSubtitle => 'Reproduzir som com as notificações';

  @override
  String get specificDaysOfMonth => 'Dias Específicos do Mês';

  @override
  String get specificDaysOfWeek => 'Dias Específicos da Semana';

  @override
  String get specificDaysOfYear => 'Dias Específicos do Ano';

  @override
  String get spendingAdvisorNoBudget =>
      'Defina um orçamento para obter conselhos.';

  @override
  String get spendingAdvisorOnTrack =>
      'Ótimo! Você está totalmente dentro do seu orçamento.';

  @override
  String get spendingAdvisorOverBudget =>
      'Você excedeu o orçamento. Pare seus gastos.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'Você pode gastar $amount por dia.';
  }

  @override
  String get spendingAdvisorTitle => 'Consultor de Gastos';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Reduza os gastos diários em $amount para se manter no caminho.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'Ótimo! Você está gastando $amount menos do que a média diária.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'Aviso! Você está gastando $amount mais do que a média diária.';
  }

  @override
  String get spin => 'GIRAR';

  @override
  String get spinAgain => 'Girar Novamente';

  @override
  String get start => 'Iniciar';

  @override
  String get startDate => 'Data de Início';

  @override
  String get startDateLabel => 'Início';

  @override
  String get startDayLabel => 'Dia de início (1-365)';

  @override
  String get startJourney => 'Inicie Sua Jornada';

  @override
  String get startTest => 'Iniciar Teste';

  @override
  String get startTestDesc =>
      'Se você completar o teste, receberá sugestões personalizadas e recomendações de hábitos. Você pode pular este passo agora se desejar.';

  @override
  String get startTestTitle => 'Deseja iniciar o teste de personalidade?';

  @override
  String get startTime => 'Hora de Início';

  @override
  String get startTrackingFinances =>
      'Comece a rastrear suas finanças e assuma o controle de seus gastos.';

  @override
  String get startTrackingMood =>
      'Comece a rastrear seu humor para ver as análises';

  @override
  String get startsOn => 'Começa em';

  @override
  String get statsActiveDays => 'Dias Ativos';

  @override
  String get statusLabel => 'Status';

  @override
  String get step => 'Passo';

  @override
  String stepOf(Object current, Object total) {
    return 'Passo $current de $total';
  }

  @override
  String get steps => 'Passos';

  @override
  String get stopwatchLabel => 'CRONÔMETRO';

  @override
  String streakDays(Object count) {
    return '$count dias';
  }

  @override
  String get streakIndicator => 'Indicador de sequência';

  @override
  String get streakIndicatorDesc => 'Mostrar efeitos de chama e gelo';

  @override
  String get subEmotionAmazing => 'Incrível';

  @override
  String get subEmotionAngry => 'Zangado';

  @override
  String get subEmotionAnxious => 'Ansioso';

  @override
  String get subEmotionBlessed => 'Abençoado';

  @override
  String get subEmotionBored => 'Entediado';

  @override
  String get subEmotionCalm => 'Calmo';

  @override
  String get subEmotionCheerful => 'Alegre';

  @override
  String get subEmotionConfident => 'Confiante';

  @override
  String get subEmotionConfused => 'Confuso';

  @override
  String get subEmotionDemoralized => 'Desmoralizado';

  @override
  String get subEmotionDetermined => 'Determinado';

  @override
  String get subEmotionDistracted => 'Distraído';

  @override
  String get subEmotionDrained => 'Exausto';

  @override
  String get subEmotionEmpty => 'Vazio';

  @override
  String get subEmotionEnergetic => 'Enérgico';

  @override
  String get subEmotionEnthusiastic => 'Entusiasta';

  @override
  String get subEmotionEuphoric => 'Eufórico';

  @override
  String get subEmotionExcited => 'Animado';

  @override
  String get subEmotionExhausted => 'Esgotado';

  @override
  String get subEmotionGrateful => 'Grato';

  @override
  String get subEmotionGuilty => 'Culpado';

  @override
  String get subEmotionHappy => 'Feliz';

  @override
  String get subEmotionHelpless => 'Desamparado';

  @override
  String get subEmotionHopeful => 'Esperançoso';

  @override
  String get subEmotionHopeless => 'Sem esperança';

  @override
  String get subEmotionHurt => 'Magoado';

  @override
  String get subEmotionIndecisive => 'Indeciso';

  @override
  String get subEmotionInsecure => 'Inseguro';

  @override
  String get subEmotionLonely => 'Solitário';

  @override
  String get subEmotionLoving => 'Amoroso';

  @override
  String get subEmotionMotivated => 'Motivado';

  @override
  String get subEmotionNumb => 'Insensível';

  @override
  String get subEmotionOrdinary => 'Comum';

  @override
  String get subEmotionOverwhelmed => 'Sobrecarregado';

  @override
  String get subEmotionPeaceful => 'Pacífico';

  @override
  String get subEmotionProud => 'Orgulhoso';

  @override
  String get subEmotionRegretful => 'Arrependido';

  @override
  String get subEmotionSad => 'Triste';

  @override
  String get subEmotionSelection =>
      'Vamos descrever esse sentimento com mais detalhes';

  @override
  String get subEmotionStressed => 'Estressado';

  @override
  String get subEmotionTired => 'Cansado';

  @override
  String get subEmotionUnstoppable => 'Imparável';

  @override
  String get subscribeToEnjoyPremium =>
      'Assine para desfrutar de recursos premium';

  @override
  String get subscription => 'Assinatura';

  @override
  String get subscriptionDetails => 'Detalhes da Assinatura';

  @override
  String subtaskIndex(Object index) {
    return 'Subtarefa $index';
  }

  @override
  String get subtasks => 'Subtarefas';

  @override
  String get subtasksTitle => 'Subtarefas';

  @override
  String get subtasksType => 'Subtarefas';

  @override
  String get subtasksTypeDesc => 'Multitarefa';

  @override
  String get success => 'Sucesso';

  @override
  String get successfulDayLegend => 'Dia de sucesso';

  @override
  String successfulDaysCount(Object count) {
    return '$count Dias de Sucesso';
  }

  @override
  String get sundayShort => 'Dom';

  @override
  String get systemInfo => 'Informações do Sistema';

  @override
  String get systemTheme => 'Tema do sistema';

  @override
  String get tapFabToCreate => 'Toque no botão + para começar';

  @override
  String get tapSpinToStart => 'Toque para girar a roleta';

  @override
  String get tapToPickImage => 'Toque para escolher uma imagem';

  @override
  String get target => 'Meta';

  @override
  String get targetDurationMinutes => 'Duração da Meta (minutos)';

  @override
  String targetShort(Object value) {
    return 'Meta: $value';
  }

  @override
  String get targetType => 'Tipo de Meta';

  @override
  String get targetValue => 'Valor da Meta';

  @override
  String get targetValueLabel => 'Valor da Meta';

  @override
  String get taskAdded => 'Tarefa adicionada';

  @override
  String taskAddedSnackbar(Object title) {
    return 'Tarefa $title adicionada! ✅';
  }

  @override
  String get taskCompleted => 'Concluído';

  @override
  String taskDeletedMessage(Object title) {
    return 'Tarefa excluída';
  }

  @override
  String get taskDescription => 'Descrição (Opcional)';

  @override
  String get taskPending => 'Pendente';

  @override
  String get taskTitle => 'Título da Tarefa';

  @override
  String get taskTitleRequired => 'O título da tarefa é obrigatório';

  @override
  String get tellMeYourDream =>
      'Conte-me seu sonho. Eu te ajudarei a construir um Mural de Visão.';

  @override
  String get tellUsMore => 'Conte-nos mais';

  @override
  String get templateDetailsNotFound => 'Detalhes do modelo não encontrados';

  @override
  String get templatesTabManual => 'Manual';

  @override
  String get templatesTabReady => 'Pronto';

  @override
  String get testsSection => 'Testes';

  @override
  String get textLabel => 'Texto';

  @override
  String get theWinnerIs => 'O vencedor é:';

  @override
  String get theme => 'Tema';

  @override
  String get themeAbyss => 'Abismo';

  @override
  String get themeAbyssDesc => 'Escuro e Sofisticado';

  @override
  String get themeBlush => 'Blush';

  @override
  String get themeBlushDesc => 'Doce e Feminino';

  @override
  String get themeCotton => 'Algodão';

  @override
  String get themeCottonDesc => 'Neutro e Quente';

  @override
  String get themeCream => 'Creme';

  @override
  String get themeCreamDesc => 'Quente e Suave';

  @override
  String get themeCrimson => 'Carmesim';

  @override
  String get themeCrimsonDesc => 'Ousado e Apaixonado';

  @override
  String get themeDetails => 'Detalhes do Tema';

  @override
  String get themeForest => 'Floresta';

  @override
  String get themeForestDesc => 'Rico e Orgânico';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeLavenderDesc => 'Calmo e Sonhador';

  @override
  String get themeMatcha => 'Matcha';

  @override
  String get themeMatchaDesc => 'Verde Fresco';

  @override
  String get themeMauve => 'Malva';

  @override
  String get themeMauveDesc => 'Elegante e Romântico';

  @override
  String get themeMidnight => 'Meia-noite';

  @override
  String get themeMidnightDesc => 'Profundo e Misterioso';

  @override
  String get themeOcean => 'Oceano';

  @override
  String get themeOceanDesc => 'Profundo e Sereno';

  @override
  String get themeRose => 'Rosa';

  @override
  String get themeRoseDesc => 'Suave e Quente';

  @override
  String get themeSelection => 'Seleção de Tema';

  @override
  String get themeSky => 'Céu';

  @override
  String get themeSkyDesc => 'Leve e Arejado';

  @override
  String get themeSlate => 'Ardósia';

  @override
  String get themeSlateDesc => 'Moderno e Frio';

  @override
  String get themeSunset => 'Pôr do Sol';

  @override
  String get themeSunsetDesc => 'Quente e Dourado';

  @override
  String get themeVintageRed => 'Vermelho Vintage';

  @override
  String get themeVintageRedDesc => 'Vermelho clássico e eterno';

  @override
  String get thisFeatureIsPremium => 'Este recurso é Premium';

  @override
  String get thisMonth => 'Este mês';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisYear => 'Este ano';

  @override
  String get thursdayShort => 'Qui';

  @override
  String get timer => 'Temporizador';

  @override
  String get timerCreateTimerHabitFirst =>
      'Crie um hábito com temporizador primeiro';

  @override
  String get timerDescription => 'Rastreio baseado em tempo';

  @override
  String get timerExample => 'Faça um treino de 30 minutos';

  @override
  String get timerHabitLabel => 'Hábito com Temporizador';

  @override
  String get timerPause => 'Pausar';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Duração pendente: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'Pendente: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Pausa';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Trabalho Concluído: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Ciclo de Pausa Longa (ex: 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Pausa Longa (min)';

  @override
  String get timerPomodoroSettings => 'Configurações Pomodoro';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Pausa Curta (min)';

  @override
  String get timerPomodoroSkipPhase => 'Pular Fase';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Trabalho (min)';

  @override
  String get timerPomodoroWorkPhase => 'Trabalho';

  @override
  String get timerQuickPresets => 'Ajustes Rápidos';

  @override
  String get timerResume => 'Retomar';

  @override
  String get timerSaveDurationTitle => 'Salvar Duração';

  @override
  String get timerSaveSessionTitle => 'Salvar Sessão';

  @override
  String get timerSessionAlreadySaved => 'Esta sessão já foi salva';

  @override
  String get timerSetDurationFirst => 'Defina a duração primeiro';

  @override
  String get timerSettings => 'Configurações do Temporizador';

  @override
  String get timerStop => 'Parar';

  @override
  String get timerTabCountdown => 'Contagem Regressiva';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Cronômetro';

  @override
  String get timerTracking => 'Rastreio do temporizador';

  @override
  String get timerType => 'Temporizador';

  @override
  String get times => 'Vezes';

  @override
  String get timezone => 'Fuso Horário';

  @override
  String get titleHint => 'Ex: Supermercado, Freelance, etc.';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get today => 'Hoje';

  @override
  String get todaysHabits => 'Hábitos de Hoje';

  @override
  String get tokenEarnedSuccess => '+1 token ganho! 🎉';

  @override
  String get tomorrow => 'Amanhã';

  @override
  String get topCategories => 'Principais Categorias';

  @override
  String get totalDuration => 'Duração Total';

  @override
  String get totalEntries => 'Total de Entradas';

  @override
  String get totalMembersLabel => 'Total de membros';

  @override
  String get totalProgress => 'Progresso total';

  @override
  String get totalSuccessfulDays => 'Total de dias de sucesso';

  @override
  String get totalUnsuccessfulDays => 'Total de dias sem sucesso';

  @override
  String get trackEarnings => 'Rastreie seus ganhos';

  @override
  String get trackSpending => 'Rastreie seus gastos';

  @override
  String get trends => 'Tendências';

  @override
  String get trialCancelEffect =>
      'Se você cancelar durante o teste grátis, não será cobrado imediatamente.';

  @override
  String get trialInfo =>
      '14 dias de teste grátis, cancele a qualquer momento.';

  @override
  String get tuesdayShort => 'Ter';

  @override
  String get typeEmoji => 'Digite um emoji';

  @override
  String get typeEmojiHint => 'Digite um emoji do teclado';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get typeNotChangeable => 'O tipo não pode ser alterado';

  @override
  String get unassignLinkedDailyTasks =>
      'Desvincular tarefas diárias vinculadas';

  @override
  String get unassignLinkedHabits => 'Desvincular hábitos vinculados';

  @override
  String get undo => 'Desfazer';

  @override
  String get uninterruptedUsage => 'Uso ininterrupto';

  @override
  String get unit => 'Unidade';

  @override
  String get unitAdet => 'un';

  @override
  String get unitAdim => 'passo';

  @override
  String get unitBardak => 'copo';

  @override
  String get unitHint => 'Unidade (copo, passo, página...)';

  @override
  String get unitKalori => 'cal';

  @override
  String get unitKez => 'vezes';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'litro';

  @override
  String get unitSayfa => 'página';

  @override
  String get unknownList => 'Lista Desconhecida';

  @override
  String get unlimitedDataStorage => 'Armazenamento ilimitado de dados';

  @override
  String get unlistedItems => 'Não Listados';

  @override
  String get unlockAllFeatures =>
      'Desbloqueie todos os recursos e remova limites.';

  @override
  String get unnamedBackup => 'sem nome';

  @override
  String get update => 'Atualizar';

  @override
  String get usePlayStoreToManage =>
      'Use a Google Play Store para gerenciar sua assinatura.';

  @override
  String get validity => 'Validade';

  @override
  String get valueLabel => 'Valor';

  @override
  String get vibration => 'Vibração';

  @override
  String get vibrationSubtitle => 'Vibrar com as notificações';

  @override
  String get viewInvoicesOnPlayStore =>
      'Veja suas faturas na Google Play Store';

  @override
  String get vision => 'Visão';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'Esta visão usará o último dia no modelo: $day.';
  }

  @override
  String get visionBoard => 'Mural de Visão';

  @override
  String get visionBoardDesc =>
      'Crie uma visão para organizar suas metas e acompanhar sua jornada';

  @override
  String get visionBoardViewTooltip => 'Visualização do mural';

  @override
  String get visionCreateTitle => 'Criar Visão';

  @override
  String get visionDurationDaysLabel => 'Duração (dias)';

  @override
  String get visionDurationNote =>
      'Nota: Quando a visão começa, uma duração total é definida; se o dia final exceder essa duração, ela será encurtada automaticamente.';

  @override
  String get visionEditTitle => 'Editar Visão';

  @override
  String get visionEmptyDescription =>
      'Visualize seus objetivos e adicione sua primeira visão para transformar seus sonhos em realidade.';

  @override
  String get visionEndDayInvalid => 'O dia final deve estar entre 1 e 365';

  @override
  String get visionEndDayLess =>
      'O dia final não pode ser menor que o dia inicial';

  @override
  String get visionEndDayQuestion => 'Em que dia da visão ela deve terminar?';

  @override
  String get visionEndDayRequired => 'Insira o dia final';

  @override
  String get visionFreeformTooltip => 'Mural livre';

  @override
  String get visionNoEndDurationInfo =>
      'Nenhum dia final especificado. A visão começará sem prazo definido.';

  @override
  String get visionPlural => 'Visões';

  @override
  String get visionSettingsTooltip => 'Configurações do mural livre';

  @override
  String get visionStartDayInvalid => 'O dia inicial deve estar entre 1 e 365';

  @override
  String get visionStartDayQuestion => 'Em que dia da visão ela deve começar?';

  @override
  String get visionStartFailed => 'Não foi possível iniciar a visão.';

  @override
  String get visionStartLabel => 'Início da visão: ';

  @override
  String visionStartedMessage(Object title) {
    return 'Visão iniciada: $title';
  }

  @override
  String get visionTasks => 'Tarefas da Visão';

  @override
  String get visual => 'Visual';

  @override
  String get warmJournal => 'Diário Aconchegante';

  @override
  String get warmJournalDesc => 'Diário acolhedor e rastreio de humor';

  @override
  String get watchAdForToken => 'Assistir Anúncio (+1 Token)';

  @override
  String get wednesdayShort => 'Qua';

  @override
  String get weekDaysShort => 'Seg,Ter,Qua,Qui,Sex,Sáb,Dom';

  @override
  String get weekdaysShortFri => 'Sex';

  @override
  String get weekdaysShortMon => 'Seg';

  @override
  String get weekdaysShortSat => 'Sáb';

  @override
  String get weekdaysShortSun => 'Dom';

  @override
  String get weekdaysShortThu => 'Qui';

  @override
  String get weekdaysShortTue => 'Ter';

  @override
  String get weekdaysShortWed => 'Qua';

  @override
  String get weekly => 'Semanal';

  @override
  String get weeklyDesc => 'Em dias específicos da semana';

  @override
  String get weeklyEmailSummary => 'Resumo semanal por e-mail';

  @override
  String get weeklyProgress => 'Progresso Semanal';

  @override
  String get weeklyReportsTitle => 'Relatórios Semanais';

  @override
  String get weeklySchedule => 'Semanal';

  @override
  String get weeklySummaryEmail => 'E-mail de resumo semanal';

  @override
  String get whatHappensIfCancel => 'O que acontece se eu cancelar?';

  @override
  String get whatsTheCause => 'Qual é a causa?';

  @override
  String get wheelOfFortuneDescription => 'Adicione opções e gire a roleta';

  @override
  String get wheelOfFortuneTitle => 'Roleta da Sorte';

  @override
  String get whichDays => 'Quais dias';

  @override
  String get whichDaysActive => 'Quais dias devem estar ativos?';

  @override
  String get whichMonthDays => 'Quais dias do mês?';

  @override
  String get whichWeekdays => 'Quais dias da semana?';

  @override
  String get whichYearDays => 'Quais dias do ano';

  @override
  String get worldTheme => 'Mundo';

  @override
  String get worldThemeDesc => 'Harmonia de todas as cores';

  @override
  String get writeMessage => 'Escreva uma mensagem...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP para o próximo nível';
  }

  @override
  String xpToNextLevel(Object toNext) {
    return 'para o próximo nível';
  }

  @override
  String get yearly => 'Anual';

  @override
  String get yearlyProgress => 'Progresso Anual';

  @override
  String get yesNoDescription => 'Rastreio simples de sim/não';

  @override
  String get yesNoExample => 'Eu meditei hoje?';

  @override
  String get yesNoType => 'Sim/Não';

  @override
  String get yesterday => 'Ontem';

  @override
  String get youLabel => 'Você';

  @override
  String get yourCharacterType => 'Seu Tipo de Personagem';

  @override
  String get yourEmail => 'Seu e-mail';

  @override
  String get yourEmailAddress => 'Seu Endereço de E-mail';

  @override
  String get yourMoodToday => 'Seu Humor Hoje';

  @override
  String get wizardFinish => 'Concluir';

  @override
  String get wizardNext => 'Próximo';

  @override
  String get wizardSkip => 'Pular';

  @override
  String get wizardOptional => 'Opcional';
}

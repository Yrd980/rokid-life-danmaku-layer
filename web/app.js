const SCENES = [
  {
    id: 'street',
    name: '街道',
    confidence: '92%',
    signal: '路过 Blue Bottle 第 17 次',
    scan: 'OPEN WORLD',
    backdrop: '雨夜街角 / 咖啡店橱窗 / 反光路面'
  },
  {
    id: 'cafe',
    name: '咖啡店',
    confidence: '89%',
    signal: '冰美式习惯识别',
    scan: 'CAFFEINE',
    backdrop: '排队点单 / 熟悉菜单 / 低电量补给'
  },
  {
    id: 'office',
    name: '办公室',
    confidence: '94%',
    signal: '文档凝视 12 分钟',
    scan: 'KPI WATCH',
    backdrop: '会议前 / 文档打开 / 任务堆叠'
  },
  {
    id: 'gym',
    name: '健身房',
    confidence: '87%',
    signal: '惯性对抗中',
    scan: 'BODY QUEST',
    backdrop: '跑步机旁 / 热身区 / 行动启动'
  },
  {
    id: 'store',
    name: '便利店',
    confidence: '91%',
    signal: '甜品区自动导航',
    scan: 'SNACK LOOP',
    backdrop: '深夜货架 / 关东煮热气 / 加班后'
  },
  {
    id: 'subway',
    name: '地铁',
    confidence: '85%',
    signal: '社交电量保护',
    scan: 'LOW POWER',
    backdrop: '通勤车厢 / 出口选择 / 省电模式'
  }
];

const PERSONAS = [
  {
    id: 'friend',
    name: '毒舌朋友',
    avatar: 'F',
    role: 'Persona Agent',
    tone: '犀利幽默',
    description: '嘴欠但不伤人，负责制造截图传播感。',
    enabled: true,
    strength: 3
  },
  {
    id: 'therapist',
    name: '温柔咨询师',
    avatar: 'T',
    role: 'Persona Agent',
    tone: '温和洞察',
    description: '降低压力，给情绪一个缓冲层。',
    enabled: true,
    strength: 2
  },
  {
    id: 'kid',
    name: '10 岁的你',
    avatar: 'K',
    role: 'Persona Agent',
    tone: '天真直接',
    description: '提醒初心，也偶尔扎心。',
    enabled: true,
    strength: 2
  },
  {
    id: 'cat',
    name: '你的猫',
    avatar: 'C',
    role: 'Persona Agent',
    tone: '高冷懒散',
    description: '像一只旁观你生活的冷静生物。',
    enabled: true,
    strength: 1
  },
  {
    id: 'mentor',
    name: '创业导师',
    avatar: 'M',
    role: 'Persona Agent',
    tone: '战略效率',
    description: '把人生翻译成任务面板。',
    enabled: true,
    strength: 2
  },
  {
    id: 'parallel',
    name: '平行宇宙的你',
    avatar: 'P',
    role: 'Persona Agent',
    tone: '神秘遗憾',
    description: '负责人生假设线和情绪留存。',
    enabled: true,
    strength: 2
  }
];

const DANMAKU = [
  {
    id: 'street-1',
    scene: 'street',
    persona: 'friend',
    text: '你已经路过这家店 17 次了，你俩到底谁先表白？',
    toneLabel: '吐槽',
    intensity: 1,
    memoryReference: 'Blue Bottle 路过 17 次，进入 2 次',
    reason: '连续多次靠近店门又绕开。',
    safetyLevel: 'safe',
    novelty: 82
  },
  {
    id: 'street-2',
    scene: 'street',
    persona: 'kid',
    text: '小时候的你以为长大后会很酷，现在主要是在找便宜咖啡。',
    toneLabel: '童年线',
    intensity: 2,
    memoryReference: '最近 9 天都搜索了咖啡优惠',
    reason: '长期消费和路线记忆形成反差。',
    safetyLevel: 'safe',
    novelty: 73
  },
  {
    id: 'street-3',
    scene: 'street',
    persona: 'parallel',
    text: '另一个宇宙里的你已经进去了，并且点了最贵的那杯。',
    toneLabel: '支线',
    intensity: 3,
    memoryReference: '反复路过但没进去的店排行第 1',
    reason: '把未发生选择做成轻量人生支线。',
    safetyLevel: 'safe',
    novelty: 88
  },
  {
    id: 'cafe-1',
    scene: 'cafe',
    persona: 'mentor',
    text: '咖啡因摄入 +1，实际生产力提升待观察。',
    toneLabel: 'KPI',
    intensity: 1,
    memoryReference: '压力大时冰美式概率 73%',
    reason: '咖啡购买频率和待办完成时间没有稳定正相关。',
    safetyLevel: 'safe',
    novelty: 68
  },
  {
    id: 'cafe-2',
    scene: 'cafe',
    persona: 'friend',
    text: '你点冰美式的熟练程度，像是在续命而不是消费。',
    toneLabel: '吐槽',
    intensity: 2,
    memoryReference: '本周冰美式 4 杯',
    reason: '进店后几乎没有菜单犹豫。',
    safetyLevel: 'safe',
    novelty: 78
  },
  {
    id: 'cafe-3',
    scene: 'cafe',
    persona: 'therapist',
    text: '你不是需要咖啡，你是需要一个可以慢下来的理由。',
    toneLabel: '安抚',
    intensity: 1,
    memoryReference: '周一上午情绪通常偏低',
    reason: '在低电量时段给出低压力解释。',
    safetyLevel: 'safe',
    novelty: 76
  },
  {
    id: 'office-1',
    scene: 'office',
    persona: 'friend',
    text: '你打开文档 12 分钟了，目前贡献是改了标题大小。',
    toneLabel: '效率',
    intensity: 1,
    memoryReference: '文档启动后 15 分钟内常改格式',
    reason: '重复格式调整，未进入正文编辑。',
    safetyLevel: 'safe',
    novelty: 83
  },
  {
    id: 'office-2',
    scene: 'office',
    persona: 'mentor',
    text: '当前 KPI：假装忙碌完成度 87%。',
    toneLabel: '任务化',
    intensity: 2,
    memoryReference: '会议前 20 分钟高频切窗口',
    reason: '用游戏指标表达轻度拖延。',
    safetyLevel: 'safe',
    novelty: 75
  },
  {
    id: 'office-3',
    scene: 'office',
    persona: 'therapist',
    text: '你现在的焦虑，也许不是事情太多，是不知道先做哪一个。',
    toneLabel: '观察',
    intensity: 1,
    memoryReference: '任务列表超过 8 条时完成率下降',
    reason: '工作模式下保留提醒，减少吐槽。',
    safetyLevel: 'safe',
    novelty: 71
  },
  {
    id: 'gym-1',
    scene: 'gym',
    persona: 'friend',
    text: '你看跑步机的眼神，像在看前任朋友圈。',
    toneLabel: '吐槽',
    intensity: 2,
    memoryReference: '跑步机观察 4 分钟，启动 0 次',
    reason: '只吐槽犹豫行为，不攻击身体。',
    safetyLevel: 'safe',
    novelty: 80
  },
  {
    id: 'gym-2',
    scene: 'gym',
    persona: 'therapist',
    text: '今天来这里，本身就已经赢过了昨天的惯性。',
    toneLabel: '鼓励',
    intensity: 1,
    memoryReference: '上次健身记录 11 天前',
    reason: '饮食和身材保护开启，不输出羞辱性评论。',
    safetyLevel: 'safe',
    novelty: 74
  },
  {
    id: 'store-1',
    scene: 'store',
    persona: 'friend',
    text: '你说只是进来看看，但手已经自动导航到甜品区。',
    toneLabel: '便利店',
    intensity: 1,
    memoryReference: '便利店甜品区停留率 68%',
    reason: '描述行为路径，不评价饮食选择。',
    safetyLevel: 'safe',
    novelty: 79
  },
  {
    id: 'store-2',
    scene: 'store',
    persona: 'parallel',
    text: '另一个宇宙里你买了沙拉，但那个宇宙目前观测不到。',
    toneLabel: '支线',
    intensity: 2,
    memoryReference: '个人梗：观测不到',
    reason: '用假设人生线制造幽默，不制造焦虑。',
    safetyLevel: 'safe',
    novelty: 86
  },
  {
    id: 'subway-1',
    scene: 'subway',
    persona: 'therapist',
    text: '你现在像手机省电模式，能不社交就先别强撑。',
    toneLabel: '低电量',
    intensity: 1,
    memoryReference: '通勤后社交回复延迟更长',
    reason: '识别到通勤和低社交电量模式。',
    safetyLevel: 'safe',
    novelty: 77
  },
  {
    id: 'subway-2',
    scene: 'subway',
    persona: 'friend',
    text: '你站得像很有方向感，其实只是在等人群替你决定出口。',
    toneLabel: '通勤',
    intensity: 2,
    memoryReference: '同站口犹豫 5 次',
    reason: '来自动线记忆，不评价陌生人。',
    safetyLevel: 'safe',
    novelty: 81
  }
];

const MEMORY_ITEMS = [
  { id: 'm1', type: '地点', title: 'Blue Bottle', detail: '路过 17 次，只进去 2 次', weight: '高频', scenes: ['street', 'cafe'] },
  { id: 'm2', type: '习惯', title: '压力冰美式', detail: '压力大时冰美式概率 73%', weight: '稳定', scenes: ['cafe', 'office'] },
  { id: 'm3', type: '人物', title: 'Emily', detail: '聊天高频词是“改天”', weight: '社交', scenes: ['street', 'subway'] },
  { id: 'm4', type: '情绪', title: '周一上午', detail: '情绪通常偏低，需要低压力提醒', weight: '模式', scenes: ['cafe', 'office', 'subway'] },
  { id: 'm5', type: '行为', title: '明天健身', detail: '连续 9 天说“明天开始”', weight: '循环', scenes: ['gym'] },
  { id: 'm6', type: '个人梗', title: '观测不到宇宙', detail: '常用于温和吐槽未发生选择', weight: '梗', scenes: ['store', 'street'] }
];

const SAFETY_ITEMS = [
  { id: 'datingMode', title: '约会模式', detail: '减少毒舌，增加温柔观察', enabled: false },
  { id: 'workMode', title: '工作模式', detail: '只保留提醒，不做吐槽', enabled: false },
  { id: 'lowMoodMode', title: '情绪低落模式', detail: '自动降低负面弹幕', enabled: true },
  { id: 'sensitiveMute', title: '敏感场景静默', detail: '医院、面试、争吵等自动静音', enabled: true },
  { id: 'foodProtection', title: '饮食保护', detail: '禁止身材和饮食羞辱', enabled: true },
  { id: 'socialProtection', title: '社交保护', detail: '不评价外貌、身份和收入', enabled: true }
];

const NPCS = [
  {
    name: '小王',
    role: '同事 NPC',
    level: 'Lv.12',
    status: '稳定但略显塑料',
    advice: '不要和他讨论周报格式，会陷入无限循环。'
  },
  {
    name: 'Emily',
    role: '朋友 NPC',
    level: 'Lv.18',
    status: '高频约饭，低频成行',
    advice: '直接给两个时间选项，不要再说有空约。'
  }
];

const RECAP_ITEMS = [
  { label: '标题', value: '昨天的你：在努力和摆烂之间反复横跳' },
  { label: '最佳弹幕', value: '你在便利店门口犹豫 23 秒，人生重大决策 +1' },
  { label: '情绪曲线', value: '上午低电量，下午假装高效，晚上精神复活' },
  { label: '今日建议', value: '把第一件事做小一点，先赢 15 分钟' }
];

const STAGES = [
  { id: 'scene_locked', label: 'Scene', agent: 'Scene Parser' },
  { id: 'memory_retrieving', label: 'Memory', agent: 'Memory Retriever' },
  { id: 'persona_drafting', label: 'Drafts', agent: 'Persona Agents' },
  { id: 'safety_review', label: 'Safety', agent: 'Safety Moderator' },
  { id: 'arbitration', label: 'Pick', agent: 'Arbiter' },
  { id: 'danmaku_live', label: 'Output', agent: 'Danmaku Renderer' }
];

const state = {
  sceneId: new URLSearchParams(window.location.search).get('scene') || 'street',
  activeTab: 'live',
  intensity: 2,
  quiet: false,
  paused: false,
  selectedDanmakuId: '',
  favoriteIds: [],
  personas: PERSONAS.map((persona) => ({ ...persona })),
  safetyItems: SAFETY_ITEMS.map((item) => ({ ...item })),
  discussionRun: null,
  generatedItems: []
};

const app = document.querySelector('#app');

function byId(items, id) {
  return items.find((item) => item.id === id) || items[0];
}

function getScene() {
  return byId(SCENES, state.sceneId);
}

function getPersona(id) {
  return byId(state.personas, id);
}

function getActiveMemories() {
  const matched = MEMORY_ITEMS.filter((item) => item.scenes.includes(state.sceneId));
  return matched.length > 0 ? matched.slice(0, 3) : MEMORY_ITEMS.slice(0, 2);
}

function getCandidates() {
  const items = DANMAKU.concat(state.generatedItems);
  return items
    .filter((item) => {
      const persona = getPersona(item.persona);
      return (
        item.scene === state.sceneId &&
        persona &&
        persona.enabled &&
        item.intensity <= state.intensity &&
        item.intensity <= persona.strength
      );
    })
    .slice(0, state.quiet ? 2 : 5);
}

function scoreCandidate(item) {
  const persona = getPersona(item.persona);
  const memoryBoost = getActiveMemories().some((memory) => item.memoryReference.indexOf(memory.title) >= 0) ? 12 : 4;
  const quietBoost = state.quiet && item.persona === 'therapist' ? 20 : 0;
  const strengthBoost = persona ? persona.strength * 6 : 0;
  const intensityPenalty = item.intensity > state.intensity ? 50 : item.intensity * 3;
  return item.novelty + memoryBoost + quietBoost + strengthBoost - intensityPenalty;
}

function reviewCandidate(item) {
  const workMode = byId(state.safetyItems, 'workMode').enabled;
  const foodProtection = byId(state.safetyItems, 'foodProtection').enabled;
  const lowMoodMode = byId(state.safetyItems, 'lowMoodMode').enabled;
  const isSharp = item.persona === 'friend';
  const isFood = item.scene === 'store' || item.scene === 'cafe';

  if (state.quiet && item.persona !== 'therapist') {
    return { verdict: 'soften', note: 'Quiet mode favors therapist or neutral output.' };
  }
  if (workMode && isSharp) {
    return { verdict: 'soften', note: 'Work mode reduces roast-style comments.' };
  }
  if (foodProtection && isFood && /身材|胖|瘦|羞辱/.test(item.text)) {
    return { verdict: 'mute', note: 'Food protection blocks body or food shaming.' };
  }
  if (lowMoodMode && item.intensity >= 3 && isSharp) {
    return { verdict: 'soften', note: 'Low mood mode lowers sharp high-intensity lines.' };
  }
  return { verdict: 'pass', note: 'No active safety rule blocks this candidate.' };
}

function buildDiscussionRun() {
  const scene = getScene();
  const memories = getActiveMemories();
  const rawCandidates = getCandidates();
  const candidates = rawCandidates.map((item) => {
    const safety = reviewCandidate(item);
    return {
      ...item,
      personaName: getPersona(item.persona).name,
      avatar: getPersona(item.persona).avatar,
      safety,
      score: scoreCandidate(item) - (safety.verdict === 'soften' ? 8 : safety.verdict === 'mute' ? 999 : 0)
    };
  });
  const surviving = candidates.filter((item) => item.safety.verdict !== 'mute');
  const pick = surviving.sort((a, b) => b.score - a.score)[0] || null;
  const finalDanmaku = pick
    ? {
        ...pick,
        text:
          pick.safety.verdict === 'soften'
            ? softenText(pick)
            : pick.text
      }
    : null;

  return {
    stage: finalDanmaku ? 'danmaku_live' : 'safety_review',
    scene,
    memories,
    candidates,
    safetyVerdicts: candidates.map((item) => ({
      id: item.id,
      personaName: item.personaName,
      verdict: item.safety.verdict,
      note: item.safety.note
    })),
    arbiterPick: finalDanmaku,
    finalDanmaku,
    reason: finalDanmaku
      ? `Arbiter picked ${finalDanmaku.personaName}: relevance ${finalDanmaku.score}, memory fit, safety margin.`
      : 'All candidates were muted, renderer keeps the scene quiet.'
  };
}

function softenText(item) {
  if (item.persona === 'therapist') {
    return item.text;
  }
  if (item.scene === 'office') {
    return '先把第一步做小一点，文档会比焦虑更快开始动。';
  }
  if (item.scene === 'cafe') {
    return '这杯咖啡像一个暂停键，先让今天慢半拍。';
  }
  return `轻量版：${item.text}`;
}

function ensureRun() {
  if (!state.discussionRun || state.discussionRun.scene.id !== state.sceneId) {
    state.discussionRun = buildDiscussionRun();
  }
  return state.discussionRun;
}

function generateRun() {
  state.discussionRun = buildDiscussionRun();
  if (state.discussionRun.finalDanmaku && !state.paused) {
    state.selectedDanmakuId = state.discussionRun.finalDanmaku.id;
  }
  render();
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function button(label, attrs = {}, className = 'button') {
  const attrText = Object.entries(attrs)
    .map(([key, value]) => ` ${key}="${escapeHtml(value)}"`)
    .join('');
  return `<button class="${className}"${attrText}>${label}</button>`;
}

function render() {
  const scene = getScene();
  const run = ensureRun();
  const visibleDanmaku = state.paused || !run.finalDanmaku ? [] : [run.finalDanmaku].concat(getCandidates().filter((item) => item.id !== run.finalDanmaku.id).slice(0, state.quiet ? 0 : 2));
  const selected = selectedDanmaku(run, visibleDanmaku);

  app.innerHTML = `
    <main class="shell">
      <section class="topbar">
        <div>
          <p class="eyebrow">ROKID GLASS WEB PROTOTYPE</p>
          <h1>Life Danmaku Multi-Agent Layer</h1>
        </div>
        <div class="status-grid">
          <div><span>Scene</span><strong>${escapeHtml(scene.name)}</strong></div>
          <div><span>Confidence</span><strong>${escapeHtml(scene.confidence)}</strong></div>
          <div><span>Scan</span><strong>${escapeHtml(scene.scan)}</strong></div>
        </div>
      </section>

      <section class="workspace">
        <aside class="left-panel">
          ${renderSceneControls()}
          ${renderModeControls()}
          ${renderTabs()}
        </aside>

        <section class="viewport-card">
          <div class="glasses-view">
            <img src="assets/scene-rain-cafe.png" alt="" />
            <div class="glass-shade"></div>
            <div class="reticle"></div>
            <div class="scene-chip">
              <span>${escapeHtml(scene.scan)}</span>
              <strong>${escapeHtml(scene.signal)}</strong>
              <small>${escapeHtml(scene.backdrop)}</small>
            </div>
            ${renderDanmaku(visibleDanmaku)}
            ${visibleDanmaku.length === 0 ? renderQuietCard() : ''}
          </div>
          ${renderDetail(selected, run)}
        </section>

        <aside class="right-panel">
          ${renderDiscussionRail(run)}
          ${renderActiveTab(run)}
        </aside>
      </section>
    </main>
  `;
}

function renderSceneControls() {
  return `
    <section class="panel">
      <div class="panel-head">
        <p class="eyebrow">Scene Input</p>
        <strong>场景</strong>
      </div>
      <div class="scene-list">
        ${SCENES.map((scene) => button(scene.name, { 'data-scene': scene.id }, `button scene-button ${scene.id === state.sceneId ? 'is-active' : ''}`)).join('')}
      </div>
    </section>
  `;
}

function renderModeControls() {
  return `
    <section class="panel">
      <div class="panel-head">
        <p class="eyebrow">Runtime Controls</p>
        <strong>输出控制</strong>
      </div>
      <div class="control-grid">
        ${button('轻', { 'data-intensity': '1' }, `button ${state.intensity === 1 ? 'is-active' : ''}`)}
        ${button('标准', { 'data-intensity': '2' }, `button ${state.intensity === 2 ? 'is-active' : ''}`)}
        ${button('热闹', { 'data-intensity': '3' }, `button ${state.intensity === 3 ? 'is-active' : ''}`)}
        ${button(state.quiet ? '退出静默' : '静默', { 'data-action': 'quiet' }, `button ${state.quiet ? 'is-active' : ''}`)}
        ${button(state.paused ? '继续' : '暂停', { 'data-action': 'pause' }, `button ${state.paused ? 'is-active' : ''}`)}
        ${button('生成', { 'data-action': 'generate' }, 'button strong')}
      </div>
    </section>
  `;
}

function renderTabs() {
  const tabs = [
    ['live', '讨论'],
    ['persona', 'Agents'],
    ['memory', 'Memory'],
    ['npc', 'NPC'],
    ['recap', 'Recap'],
    ['safety', 'Safety']
  ];
  return `
    <section class="panel nav-panel">
      ${tabs.map(([id, label]) => button(label, { 'data-tab': id }, `button nav-button ${state.activeTab === id ? 'is-active' : ''}`)).join('')}
    </section>
  `;
}

function renderDanmaku(items) {
  return items
    .map((item, index) => {
      const persona = getPersona(item.persona);
      const selectedClass = item.id === state.selectedDanmakuId ? ' is-selected' : '';
      return `
        <button class="danmaku lane-${index}${selectedClass}" data-danmaku="${escapeHtml(item.id)}">
          <span class="avatar">${escapeHtml(persona.avatar)}</span>
          <span class="bubble-copy">
            <strong>${escapeHtml(persona.name)}</strong>
            <span>${escapeHtml(item.text)}</span>
          </span>
          <small>${escapeHtml(item.toneLabel)}</small>
        </button>
      `;
    })
    .join('');
}

function renderQuietCard() {
  return `
    <div class="quiet-card">
      <strong>当前场景保持静默</strong>
      <span>Pause 或安全规则正在抑制输出，讨论可以继续但 Renderer 不上屏。</span>
    </div>
  `;
}

function selectedDanmaku(run, visibleDanmaku) {
  const all = run.candidates.concat(visibleDanmaku);
  return all.find((item) => item.id === state.selectedDanmakuId) || run.finalDanmaku || null;
}

function renderDetail(item, run) {
  if (!item) {
    return `
      <div class="detail-drawer">
        <strong>等待弹幕输出</strong>
        <span>点击 Generate 让多个 agent 讨论并仲裁一条上屏弹幕。</span>
      </div>
    `;
  }

  const persona = getPersona(item.persona);
  return `
    <div class="detail-drawer">
      <div>
        <p class="eyebrow">Comment Detail</p>
        <strong>${escapeHtml(item.text)}</strong>
      </div>
      <div class="detail-grid">
        <span>Agent</span><b>${escapeHtml(persona.name)}</b>
        <span>Why now</span><b>${escapeHtml(item.reason)}</b>
        <span>Memory</span><b>${escapeHtml(item.memoryReference)}</b>
        <span>Safety</span><b>${escapeHtml(item.safety ? item.safety.verdict : 'pass')}</b>
        <span>Arbiter</span><b>${escapeHtml(run.reason)}</b>
      </div>
      <div class="feedback-row">
        ${button('好笑', { 'data-feedback': 'funny' }, 'button')}
        ${button('太狠', { 'data-feedback': 'too-hard' }, 'button')}
        ${button('别说', { 'data-feedback': 'mute' }, 'button')}
        ${button(state.favoriteIds.includes(item.id) ? '已收藏' : '收藏', { 'data-feedback': 'save', 'data-id': item.id }, `button ${state.favoriteIds.includes(item.id) ? 'is-active' : ''}`)}
      </div>
    </div>
  `;
}

function renderDiscussionRail(run) {
  const activeIndex = STAGES.findIndex((stage) => stage.id === run.stage);
  return `
    <section class="panel discussion-panel">
      <div class="panel-head">
        <p class="eyebrow">Multi-Agent Run</p>
        <strong>讨论流水线</strong>
      </div>
      <div class="stage-list">
        ${STAGES.map((stage, index) => {
          const status = index < activeIndex ? 'PASS' : index === activeIndex ? 'LIVE' : 'WAIT';
          return `
            <div class="stage ${index <= activeIndex ? 'is-done' : ''}">
              <span>${escapeHtml(stage.label)}</span>
              <strong>${status}</strong>
              <small>${escapeHtml(stage.agent)}</small>
            </div>
          `;
        }).join('')}
      </div>
    </section>
  `;
}

function renderActiveTab(run) {
  if (state.activeTab === 'persona') {
    return renderPersonaPanel();
  }
  if (state.activeTab === 'memory') {
    return renderMemoryPanel(run);
  }
  if (state.activeTab === 'npc') {
    return renderNpcPanel();
  }
  if (state.activeTab === 'recap') {
    return renderRecapPanel();
  }
  if (state.activeTab === 'safety') {
    return renderSafetyPanel(run);
  }
  return renderLiveAgentPanel(run);
}

function renderLiveAgentPanel(run) {
  return `
    <section class="panel fill-panel">
      <div class="panel-head">
        <p class="eyebrow">Agent Candidates</p>
        <strong>候选弹幕</strong>
      </div>
      <div class="candidate-list">
        ${run.candidates.map((item) => `
          <button class="candidate ${run.finalDanmaku && run.finalDanmaku.id === item.id ? 'is-picked' : ''}" data-danmaku="${escapeHtml(item.id)}">
            <span class="candidate-top">
              <b>${escapeHtml(item.personaName)}</b>
              <em>${escapeHtml(item.safety.verdict)} / ${item.score}</em>
            </span>
            <span>${escapeHtml(item.text)}</span>
            <small>${escapeHtml(item.safety.note)}</small>
          </button>
        `).join('') || '<div class="empty">没有候选。打开更多 agent 或降低安全限制。</div>'}
      </div>
    </section>
  `;
}

function renderPersonaPanel() {
  return `
    <section class="panel fill-panel">
      <div class="panel-head">
        <p class="eyebrow">Who Gets A Vote</p>
        <strong>人格 Agent</strong>
      </div>
      <div class="agent-grid">
        ${state.personas.map((persona) => `
          <article class="agent-card">
            <div class="agent-title">
              <span class="avatar">${escapeHtml(persona.avatar)}</span>
              <div>
                <strong>${escapeHtml(persona.name)}</strong>
                <small>${escapeHtml(persona.tone)}</small>
              </div>
            </div>
            <p>${escapeHtml(persona.description)}</p>
            <div class="agent-actions">
              ${button(persona.enabled ? 'ON' : 'OFF', { 'data-persona': persona.id }, `button ${persona.enabled ? 'is-active' : ''}`)}
              ${button(`强度 ${persona.strength}`, { 'data-strength': persona.id }, 'button')}
            </div>
          </article>
        `).join('')}
      </div>
    </section>
  `;
}

function renderMemoryPanel(run) {
  return `
    <section class="panel fill-panel">
      <div class="panel-head">
        <p class="eyebrow">Retrieved By Memory Agent</p>
        <strong>本轮记忆</strong>
      </div>
      <div class="memory-list">
        ${run.memories.map((memory) => `
          <article class="memory-card">
            <span>${escapeHtml(memory.type)} / ${escapeHtml(memory.weight)}</span>
            <strong>${escapeHtml(memory.title)}</strong>
            <p>${escapeHtml(memory.detail)}</p>
          </article>
        `).join('')}
      </div>
    </section>
  `;
}

function renderNpcPanel() {
  return `
    <section class="panel fill-panel">
      <div class="panel-head">
        <p class="eyebrow">Social Context</p>
        <strong>NPC 侧栏</strong>
      </div>
      <div class="npc-list">
        ${NPCS.map((npc) => `
          <article class="npc-card">
            <div>
              <strong>${escapeHtml(npc.name)}</strong>
              <span>${escapeHtml(npc.level)}</span>
            </div>
            <small>${escapeHtml(npc.role)} / ${escapeHtml(npc.status)}</small>
            <p>${escapeHtml(npc.advice)}</p>
          </article>
        `).join('')}
      </div>
    </section>
  `;
}

function renderRecapPanel() {
  return `
    <section class="panel fill-panel">
      <div class="panel-head">
        <p class="eyebrow">Daily Recap Preview</p>
        <strong>昨日高光</strong>
      </div>
      <div class="recap-list">
        ${RECAP_ITEMS.map((item) => `
          <article class="recap-row">
            <span>${escapeHtml(item.label)}</span>
            <strong>${escapeHtml(item.value)}</strong>
          </article>
        `).join('')}
      </div>
    </section>
  `;
}

function renderSafetyPanel(run) {
  return `
    <section class="panel fill-panel">
      <div class="panel-head">
        <p class="eyebrow">Moderator Verdicts</p>
        <strong>安全规则</strong>
      </div>
      <div class="safety-list">
        ${state.safetyItems.map((item) => `
          <article class="safety-row">
            <div>
              <strong>${escapeHtml(item.title)}</strong>
              <p>${escapeHtml(item.detail)}</p>
            </div>
            ${button(item.enabled ? 'ON' : 'OFF', { 'data-safety': item.id }, `button ${item.enabled ? 'is-active' : ''}`)}
          </article>
        `).join('')}
      </div>
      <div class="verdict-box">
        ${run.safetyVerdicts.map((verdict) => `
          <p><b>${escapeHtml(verdict.personaName)}</b> ${escapeHtml(verdict.verdict)} - ${escapeHtml(verdict.note)}</p>
        `).join('')}
      </div>
    </section>
  `;
}

function onClick(event) {
  const target = event.target.closest('button');
  if (!target) {
    return;
  }

  if (target.dataset.scene) {
    state.sceneId = target.dataset.scene;
    state.selectedDanmakuId = '';
    state.discussionRun = buildDiscussionRun();
    render();
    return;
  }
  if (target.dataset.intensity) {
    state.intensity = Number(target.dataset.intensity);
    state.discussionRun = buildDiscussionRun();
    render();
    return;
  }
  if (target.dataset.action === 'quiet') {
    state.quiet = !state.quiet;
    state.discussionRun = buildDiscussionRun();
    render();
    return;
  }
  if (target.dataset.action === 'pause') {
    state.paused = !state.paused;
    render();
    return;
  }
  if (target.dataset.action === 'generate') {
    generateRun();
    return;
  }
  if (target.dataset.tab) {
    state.activeTab = target.dataset.tab;
    render();
    return;
  }
  if (target.dataset.danmaku) {
    state.selectedDanmakuId = target.dataset.danmaku;
    render();
    return;
  }
  if (target.dataset.persona) {
    const persona = getPersona(target.dataset.persona);
    persona.enabled = !persona.enabled;
    state.discussionRun = buildDiscussionRun();
    render();
    return;
  }
  if (target.dataset.strength) {
    const persona = getPersona(target.dataset.strength);
    persona.strength = persona.strength >= 3 ? 1 : persona.strength + 1;
    state.discussionRun = buildDiscussionRun();
    render();
    return;
  }
  if (target.dataset.safety) {
    const item = byId(state.safetyItems, target.dataset.safety);
    item.enabled = !item.enabled;
    state.discussionRun = buildDiscussionRun();
    render();
    return;
  }
  if (target.dataset.feedback === 'save') {
    const id = target.dataset.id;
    state.favoriteIds = state.favoriteIds.includes(id)
      ? state.favoriteIds.filter((item) => item !== id)
      : state.favoriteIds.concat(id);
    render();
  }
}

app.addEventListener('click', onClick);
state.discussionRun = buildDiscussionRun();
render();

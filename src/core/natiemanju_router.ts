import os from 'node:os';
import path from 'node:path';

export const NATIEMANJU_SKILL_PATH = path.join(
  os.homedir(),
  '.codex',
  'skills',
  'natiemanju',
  'SKILL.md',
);

const ROUTE_RULES = [
  { label: 'natiemanju', pattern: /natiemanju|拿铁漫剧|AI漫剧|漫剧|漫画短剧|微短剧|短视频漫剧/iu },
  { label: '视频制作流程', pattern: /(?:制作|生成|做|创建).{0,16}(?:视频|分镜|角色|场景|道具)|(?:视频|分镜|角色|场景|道具).{0,16}(?:制作|生成|做|创建)/iu },
  { label: '剧本改编流程', pattern: /剧本.{0,16}(?:生成|制作|改编|创作|编写|拆集|续写)|(?:生成|制作|改编|创作|编写|拆集|续写).{0,16}剧本/iu },
  { label: '按集生产流程', pattern: /(?:按集|逐集|每集|第\s*[0-9一二三四五六七八九十百零两]+\s*集).{0,16}(?:生成|制作|做|继续)/iu },
] as const;

export function resolveNatiemanjuRoute(inputText: string): { matched: boolean; matchedBy: string[] } {
  const matchedBy = ROUTE_RULES
    .filter((rule) => rule.pattern.test(String(inputText ?? '')))
    .map((rule) => rule.label);
  return { matched: matchedBy.length > 0, matchedBy };
}

export function buildNatiemanjuRoutingInstructions(inputText: string): string {
  const route = resolveNatiemanjuRoute(inputText);
  if (!route.matched) {
    return '';
  }
  return [
    'CodexBridge 强制技能路由：natiemanju',
    `- 命中关键词：${route.matchedBy.join('、')}`,
    `- 必须先读取并遵循 natiemanju 技能文件：${NATIEMANJU_SKILL_PATH}`,
    '- 本轮涉及漫剧制作、剧本改编或相关图片/视频生产时，必须按 natiemanju 流程执行，不得退回普通聊天回答。',
    '- 用户未明确要求停止时，继续完成该技能当前阶段；缺少视频模型、API 配置或遇到硬阻塞时，按技能规则报告阻塞原因。',
  ].join('\n');
}

-- Table 1: Every agent run
CREATE TABLE run_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  video_url TEXT,
  video_title TEXT,
  channel_name TEXT,
  status TEXT, -- success | failed
  duration_seconds FLOAT,
  total_cost_usd FLOAT,
  error_message TEXT
);

-- Table 2: Per-agent timing and token usage
CREATE TABLE agent_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  run_id UUID REFERENCES run_logs(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  agent_name TEXT, -- audio_downloader, whisper, analyst etc
  status TEXT,
  duration_seconds FLOAT,
  tokens_used INT,
  cost_usd FLOAT,
  error TEXT
);

-- Table 3: Transcript quality tracking
CREATE TABLE transcript_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  run_id UUID REFERENCES run_logs(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  video_duration_seconds FLOAT,
  word_count INT,
  language TEXT,
  whisper_model TEXT
);

-- Table 4: Full analysis results + vector embedding
CREATE TABLE analysis_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  run_id UUID REFERENCES run_logs(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  video_date DATE,
  summary TEXT,
  market_context TEXT,
  themes TEXT[],
  bullish_signals TEXT[],
  bearish_signals TEXT[],
  actionable_insights TEXT[],
  raw_json JSONB,
  embedding vector(1536) -- pgvector column for semantic search
);

-- Table 5: Per-stock historical tracking
CREATE TABLE stock_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  run_id UUID REFERENCES run_logs(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  ticker TEXT,
  company_name TEXT,
  sentiment TEXT, -- bullish | bearish | neutral
  sentiment_score FLOAT,
  mention_count INT,
  key_points TEXT,
  news_headlines TEXT[]
);

-- Table 6: Cost tracking per run
CREATE TABLE cost_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  run_id UUID REFERENCES run_logs(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  whisper_minutes FLOAT,
  whisper_cost_usd FLOAT,
  claude_input_tokens INT,
  claude_output_tokens INT,
  claude_cost_usd FLOAT,
  embedding_tokens INT,
  embedding_cost_usd FLOAT,
  total_cost_usd FLOAT
);

-- Table 7: Error tracking
CREATE TABLE error_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  run_id UUID REFERENCES run_logs(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  agent_name TEXT,
  error_type TEXT,
  error_message TEXT,
  stack_trace TEXT,
  resolved BOOLEAN DEFAULT FALSE
);

-- Table 8: Prompt version tracking
CREATE TABLE prompt_versions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  agent_name TEXT,
  version TEXT,
  prompt_text TEXT,
  notes TEXT,
  is_active BOOLEAN DEFAULT TRUE
);
-- You should see: "Success. No rows returned" for all tables

-- Location: supabase/migrations/20250831172800_add_social_comments_table.sql
-- Social Comments Integration for Contentflow Pro
-- Extends existing schema for social media comment management

-- Create new enums for comment functionality
CREATE TYPE public.comment_sentiment AS ENUM ('positive', 'neutral', 'negative', 'spam');
CREATE TYPE public.moderation_status AS ENUM ('pending', 'approved', 'hidden', 'deleted', 'flagged');

-- Create social_comments table for dedicated comment management
CREATE TABLE public.social_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    connected_account_id UUID REFERENCES public.connected_accounts(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    commenter_name TEXT,
    commenter_avatar_url TEXT,
    commenter_profile_url TEXT,
    platform public.platform_type NOT NULL,
    sentiment public.comment_sentiment DEFAULT 'neutral'::public.comment_sentiment,
    moderation_status public.moderation_status DEFAULT 'pending'::public.moderation_status,
    ai_confidence_score DECIMAL(3,2) DEFAULT 0.50,
    is_replied BOOLEAN DEFAULT false,
    reply_content TEXT,
    replied_at TIMESTAMPTZ,
    engagement_count INTEGER DEFAULT 0,
    likes_count INTEGER DEFAULT 0,
    external_comment_id TEXT,
    thread_id TEXT,
    parent_comment_id UUID REFERENCES public.social_comments(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for efficient querying
CREATE INDEX idx_social_comments_post_id ON public.social_comments(post_id);
CREATE INDEX idx_social_comments_profile_id ON public.social_comments(profile_id);
CREATE INDEX idx_social_comments_platform ON public.social_comments(platform);
CREATE INDEX idx_social_comments_sentiment ON public.social_comments(sentiment);
CREATE INDEX idx_social_comments_moderation_status ON public.social_comments(moderation_status);
CREATE INDEX idx_social_comments_created_at ON public.social_comments(created_at);
CREATE INDEX idx_social_comments_parent_id ON public.social_comments(parent_comment_id);

-- Enable RLS
ALTER TABLE public.social_comments ENABLE ROW LEVEL SECURITY;

-- RLS Policy using Pattern 2 - Simple User Ownership
CREATE POLICY "users_manage_own_social_comments"
ON public.social_comments
FOR ALL
TO authenticated
USING (profile_id = auth.uid())
WITH CHECK (profile_id = auth.uid());

-- Create auto-moderation rules table
CREATE TABLE public.auto_moderation_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    rule_name TEXT NOT NULL,
    keywords TEXT[],
    action public.moderation_status NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_auto_moderation_rules_profile_id ON public.auto_moderation_rules(profile_id);
ALTER TABLE public.auto_moderation_rules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_manage_own_auto_moderation_rules"
ON public.auto_moderation_rules
FOR ALL
TO authenticated
USING (profile_id = auth.uid())
WITH CHECK (profile_id = auth.uid());

-- Create comment templates table
CREATE TABLE public.comment_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    template_name TEXT NOT NULL,
    template_content TEXT NOT NULL,
    tags TEXT[],
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_comment_templates_profile_id ON public.comment_templates(profile_id);
ALTER TABLE public.comment_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_manage_own_comment_templates"
ON public.comment_templates
FOR ALL
TO authenticated
USING (profile_id = auth.uid())
WITH CHECK (profile_id = auth.uid());

-- Mock data for demonstration
DO $$
DECLARE
    existing_user_id UUID;
    existing_post_id UUID;
    existing_account_id UUID;
    comment1_id UUID := gen_random_uuid();
    comment2_id UUID := gen_random_uuid();
    comment3_id UUID := gen_random_uuid();
BEGIN
    -- Get existing user ID from profiles
    SELECT id INTO existing_user_id FROM public.profiles LIMIT 1;
    SELECT id INTO existing_post_id FROM public.posts LIMIT 1;
    SELECT id INTO existing_account_id FROM public.connected_accounts LIMIT 1;
    
    -- Only create mock data if we have existing references
    IF existing_user_id IS NOT NULL AND existing_post_id IS NOT NULL THEN
        -- Insert mock social comments
        INSERT INTO public.social_comments (
            id, post_id, profile_id, connected_account_id, content, 
            commenter_name, commenter_avatar_url, platform, sentiment,
            moderation_status, ai_confidence_score, engagement_count,
            likes_count, external_comment_id
        ) VALUES
            (comment1_id, existing_post_id, existing_user_id, existing_account_id,
             'This is amazing! Love the new features you have added.',
             'Sarah Johnson', 'https://images.unsplash.com/photo-1494790108755-2616b612b47c',
             'instagram'::public.platform_type, 'positive'::public.comment_sentiment,
             'approved'::public.moderation_status, 0.89, 25, 12, 'ig_comment_1'),
            (comment2_id, existing_post_id, existing_user_id, existing_account_id,
             'Could you please provide more details about this?',
             'Mike Chen', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
             'facebook'::public.platform_type, 'neutral'::public.comment_sentiment,
             'pending'::public.moderation_status, 0.65, 8, 3, 'fb_comment_1'),
            (comment3_id, existing_post_id, existing_user_id, existing_account_id,
             'This is spam content with suspicious links.',
             'Spam User', 'https://via.placeholder.com/150',
             'twitter'::public.platform_type, 'spam'::public.comment_sentiment,
             'flagged'::public.moderation_status, 0.95, 0, 0, 'tw_comment_1');

        -- Insert auto-moderation rules
        INSERT INTO public.auto_moderation_rules (
            profile_id, rule_name, keywords, action, is_active
        ) VALUES
            (existing_user_id, 'Spam Detection', 
             ARRAY['spam', 'click here', 'free money', 'suspicious link'],
             'flagged'::public.moderation_status, true),
            (existing_user_id, 'Positive Keywords',
             ARRAY['amazing', 'love', 'great', 'awesome', 'fantastic'],
             'approved'::public.moderation_status, true);

        -- Insert comment templates
        INSERT INTO public.comment_templates (
            profile_id, template_name, template_content, tags
        ) VALUES
            (existing_user_id, 'Thank You Response',
             'Thank you for your positive feedback! We really appreciate your support.',
             ARRAY['positive', 'gratitude']),
            (existing_user_id, 'Information Request',
             'Hi there! Thanks for your question. You can find more information at our website or feel free to DM us.',
             ARRAY['neutral', 'information']),
            (existing_user_id, 'Apology Response',
             'We apologize for any inconvenience. Our team is looking into this matter and will get back to you soon.',
             ARRAY['negative', 'apology']);
    END IF;
END $$;
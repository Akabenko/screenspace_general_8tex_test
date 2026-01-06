sampler BaseTexture     : register( s0 );
sampler Tex1            : register( s1 );
sampler Tex2            : register( s2 );
sampler Tex3            : register( s3 );
sampler Tex4            : register( s4 );
sampler Tex5            : register( s5 );
sampler Tex6            : register( s6 );
sampler Tex7            : register( s7 );

struct PS_IN
{
    float2 pos          : VPOS;
    float2 vTexCoord    : TEXCOORD0;
};

static const float s = 0.25;
static const float inv_s = 1.f / 0.25f;
static const float s_2 = s * 2;
static const float s_3 = s * 3;
static const float inv_s_3 = 1.f / s_3;

#define out_rgb(tex, uv) return half4( tex2Dlod(tex, float4(uv, 0, 0) ).rgb, 1 )

half4 main(PS_IN i) : COLOR
{
    float2 uv = i.vTexCoord;
    float2 small_uv = frac(uv * inv_s);
    
    if (uv.y < s) {
        if (uv.x < s)   out_rgb(Tex1, small_uv);
        if (uv.x < s_2) out_rgb(Tex2, small_uv);
        if (uv.x < s_3) out_rgb(Tex3, small_uv);
        out_rgb(Tex4, small_uv );
    }

    if (uv.x > s_3) {
        if (uv.y < s)    out_rgb(Tex5, small_uv);
        if (uv.y < s_2)  out_rgb(Tex6, small_uv);
        out_rgb(Tex7, small_uv);
    }
    
    uv.y -= s;
    uv *= inv_s_3;
    uv.x = frac(uv.x);

    out_rgb(BaseTexture, uv );
}

/* 
┌──────────┬──────────┬──────────┬──────────┐
│   Tex1   │   Tex2   │   Tex3   │   Tex4   │
│          │          │          │          │
├──────────┴──────────┴──────────┼──────────┤
│                                │   Tex5   │
│                                │          │
│                                ├──────────┤
│          BaseTexture           │   Tex6   │
│                                │          │
│                                ├──────────┤
│                                │   Tex7   │
│                                │          │
└────────────────────────────────┴──────────┘
*/


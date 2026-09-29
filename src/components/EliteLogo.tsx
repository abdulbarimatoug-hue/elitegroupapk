import React from 'react';

interface EliteLogoProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
  showText?: boolean;
  className?: string;
  variant?: 'light' | 'dark' | 'color';
}

export const EliteLogo: React.FC<EliteLogoProps> = ({
  size = 'md',
  showText = true,
  className = '',
  variant = 'color'
}) => {
  const sizeMap = {
    sm: { img: 'w-8 h-8', textTitle: 'text-xs', textSub: 'text-[9px]' },
    md: { img: 'w-12 h-12', textTitle: 'text-sm', textSub: 'text-[10px]' },
    lg: { img: 'w-16 h-16', textTitle: 'text-base', textSub: 'text-xs' },
    xl: { img: 'w-24 h-24', textTitle: 'text-xl', textSub: 'text-sm' }
  };

  const { img, textTitle, textSub } = sizeMap[size];

  return (
    <div className={`flex items-center gap-3 ${className}`}>
      {/* Official Company Logo Emblem */}
      <div className={`relative ${img} rounded-2xl overflow-hidden bg-white p-1 shadow-md border border-[#c9a227]/40 flex-shrink-0 flex items-center justify-center`}>
        <img
          src="/logo.jpg"
          alt="شعار مجموعة النخبة للخدمات السياحية"
          className="w-full h-full object-contain"
          onError={(e) => {
            // Fallback SVG if image is loading
            (e.target as HTMLElement).style.display = 'none';
          }}
        />
      </div>

      {/* Typography with Crown */}
      {showText && (
        <div className="flex flex-col">
          <div className="flex items-center gap-1.5">
            <h1 className={`font-black tracking-wide ${
              variant === 'light' ? 'text-white' : (variant === 'dark' ? 'text-[#081a2e]' : 'text-[#004494]')
            } ${textTitle}`}>
              مجموعة النخبة
            </h1>
            {/* Crown Icon Above Text as in the logo */}
            <span className="text-[#c9a227] text-xs leading-none">👑</span>
          </div>
          <span className={`font-bold tracking-wider ${
            variant === 'light' ? 'text-[#e8d18f]' : 'text-[#0070ba]'
          } ${textSub}`}>
            للخدمات السياحية
          </span>
        </div>
      )}
    </div>
  );
};

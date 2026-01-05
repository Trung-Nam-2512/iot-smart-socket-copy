import React, { useState } from 'react';
import { Sun, Moon, Coffee, Briefcase, Zap, MoreHorizontal } from 'lucide-react';
import lampImg from '../../assets/lamp.png'; // Bạn hãy đảm bảo có ảnh này hoặc dùng placeholder

const LampDetail = () => {
  const [brightness, setBrightness] = useState(80);
  const [temp, setTemp] = useState(45); // 0: Warm, 100: Cold

  return (
    <div className="grid grid-cols-12 gap-8 animate-in fade-in zoom-in duration-700 h-full overflow-y-visible">
      
      {/* CỘT TRÁI: THIẾT BỊ & ĐỘ SÁNG */}
      <div className="col-span-12 lg:col-span-5 space-y-8">
        <div className="relative flex items-center justify-center py-10 min-h-[400px]">
          {/* Hiệu ứng hào quang (Glow) quanh đèn */}
          <div className="absolute w-[300px] h-[300px] bg-yellow-100 rounded-full blur-[100px] opacity-40"></div>
          <div className="absolute w-[400px] h-[400px] border border-slate-100 rounded-full opacity-40"></div>
          
          <img 
            src={lampImg} 
            className="w-64 relative z-10 drop-shadow-2xl transition-all duration-500" 
            style={{ filter: `brightness(${0.5 + brightness/100})` }}
            alt="Smart Lamp" 
          />
        </div>

        <div className="bg-white p-8 rounded-[2.5rem] shadow-sm space-y-8">
          {/* Status Toggle */}
          <div className="flex justify-between items-center border-b border-slate-50 pb-6">
            <span className="font-bold text-slate-400 uppercase text-xs tracking-widest">Power</span>
            <div className="flex items-center gap-3">
              <span className="text-yellow-500 font-black">ON</span>
              <div className="w-12 h-6 bg-yellow-400 rounded-full p-1 flex justify-end items-center shadow-inner cursor-pointer">
                <div className="w-4 h-4 bg-white rounded-full shadow-md"></div>
              </div>
            </div>
          </div>

          {/* Lifespan/Battery */}
          <div className="flex justify-between items-center">
            <span className="font-bold text-slate-400 uppercase text-xs tracking-widest">Bulb Life</span>
            <div className="flex items-center gap-2">
              <span className="font-black text-slate-800">85%</span>
              <div className="w-5 h-2.5 border border-green-400 rounded-[2px] p-[1px] relative">
                <div className="w-[85%] h-full bg-green-400 rounded-[1px]"></div>
              </div>
            </div>
          </div>

          {/* Brightness Slider */}
          <div className="space-y-4 pt-2">
            <div className="flex justify-between">
              <span className="font-bold text-slate-400 text-xs uppercase tracking-widest">Brightness</span>
              <span className="text-xs font-black text-slate-800">{brightness}%</span>
            </div>
            <div className="h-12 bg-slate-50 rounded-2xl relative overflow-hidden flex items-center px-1 shadow-inner border border-slate-100/50">
              <div 
                className="h-10 bg-gradient-to-r from-yellow-300 to-yellow-500 rounded-xl shadow-lg flex items-center px-4 gap-3 transition-all duration-300"
                style={{ width: `${brightness}%` }}
              >
                <Sun size={16} className="text-white" />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* CỘT PHẢI: MÀU SẮC & CHẾ ĐỘ */}
      <div className="col-span-12 lg:col-span-7 space-y-8">
        <div className="bg-white p-12 rounded-[3rem] shadow-sm flex flex-col items-center justify-center relative min-h-[500px]">
          <h3 className="absolute top-10 left-10 font-black text-xl text-slate-800 tracking-tight">Color Temperature</h3>
          
          {/* Color Temp Dial */}
          <div className="w-72 h-72 rounded-full border-[18px] border-slate-50 flex flex-col items-center justify-center relative">
             <div className="text-center">
                <span className="text-5xl font-black text-slate-800 tracking-tighter">4500</span>
                <span className="text-xl font-black text-slate-800 ml-1">K</span>
                <p className="text-[10px] font-bold text-slate-400 uppercase mt-2 tracking-widest">Natural White</p>
             </div>
             {/* Knob */}
             <div 
                className="absolute w-8 h-8 bg-white rounded-full border-4 border-yellow-400 shadow-lg z-20 cursor-pointer"
                style={{ 
                    transform: `rotate(${temp * 3.6}deg) translateY(-144px)`,
                    transition: 'transform 0.3s ease-out'
                }}
             ></div>
             {/* Gradient Track */}
             <div className="absolute inset-0 rounded-full border-[18px] border-transparent border-t-orange-200 border-r-yellow-100 border-b-blue-50 border-l-blue-200 opacity-40"></div>
          </div>

          {/* Quick Scene Modes */}
          <div className="grid grid-cols-4 gap-6 mt-16 w-full px-6">
             <ModeButton icon={<Coffee />} label="Relax" active={true} color="bg-orange-400" />
             <ModeButton icon={<Briefcase />} label="Work" color="bg-blue-500" />
             <ModeButton icon={<Moon />} label="Night" color="bg-indigo-600" />
             <ModeButton icon={<Zap />} label="Reading" color="bg-yellow-500" />
          </div>
        </div>

        {/* Schedule/Scenes */}
        <div className="bg-white p-8 rounded-[2.5rem] shadow-sm">
           <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-2 font-black text-xl text-slate-800">
                <h3>Auto Schedule</h3>
                <span className="w-6 h-6 bg-slate-50 rounded-full flex items-center justify-center text-[10px] text-slate-400">2</span>
              </div>
              <MoreHorizontal className="text-slate-300" />
           </div>
           
           <div className="space-y-4">
              <ScheduleItem title="Morning Sun" time="06:30 AM" active={true} />
              <ScheduleItem title="Sweet Dreams" time="11:00 PM" active={false} />
           </div>
        </div>
      </div>
    </div>
  );
};

// Sub-components
const ModeButton = ({ icon, label, active = false, color }) => (
  <div className="flex flex-col items-center gap-3 group cursor-pointer">
    <div className={`w-16 h-16 rounded-[1.5rem] flex items-center justify-center transition-all ${active ? `${color} text-white shadow-xl scale-105` : 'bg-white border border-slate-100 text-slate-300 hover:bg-slate-50'}`}>
      {React.cloneElement(icon, { size: 24 })}
    </div>
    <span className={`text-[11px] font-black uppercase tracking-tighter ${active ? 'text-slate-800' : 'text-slate-400 font-bold'}`}>{label}</span>
  </div>
);

const ScheduleItem = ({ title, time, active }) => (
    <div className={`flex justify-between items-center p-5 rounded-[1.5rem] ${active ? 'bg-yellow-50/50 border border-yellow-100/50' : 'bg-slate-50/50'}`}>
      <div className="flex items-center gap-4">
        <div className={`w-12 h-12 rounded-2xl flex items-center justify-center shadow-sm ${active ? 'bg-white' : 'bg-slate-100'}`}>
            <Sun size={20} className={active ? 'text-yellow-500' : 'text-slate-300'} />
        </div>
        <div>
          <p className="font-bold text-slate-800 leading-none mb-1.5">{title}</p>
          <p className={`text-[10px] font-bold uppercase ${active ? 'text-yellow-600' : 'text-slate-300'}`}>Starts at {time}</p>
        </div>
      </div>
      <div className={`w-10 h-5 rounded-full relative p-1 ${active ? 'bg-yellow-400' : 'bg-slate-200'}`}>
        <div className={`w-3 h-3 bg-white rounded-full transition-all ${active ? 'ml-auto' : ''}`}></div>
      </div>
    </div>
);

export default LampDetail;
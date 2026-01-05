import React from 'react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { ArrowLeft, TrendingUp, TrendingDown, ChevronRight } from 'lucide-react';

const data = [
  { day: 'M', usage: 5 }, { day: 'T', usage: 8 }, { day: 'W', usage: 6 },
  { day: 'T', usage: 17 }, { day: 'F', usage: 10 }, { day: 'S', usage: 11 },
  { day: 'S', usage: 5 },
];

const roomsData = [
  { name: 'Living Room', devices: 4, usage: 20, img: 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?auto=format&fit=crop&q=80&w=300' },
  { name: 'Bedroom', devices: 4, usage: 20, img: 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&q=80&w=300' },
  { name: 'Bathroom', devices: 4, usage: 20, img: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&q=80&w=300' },
];

const Statistics = () => {
  return (
    <div className="flex flex-col h-full bg-slate-50 overflow-y-auto pb-10">
      
      {/* SECTION 1: DARK DASHBOARD */}
      <div className="bg-[#1e293b] text-white p-8 rounded-b-[3rem] shadow-2xl">
        <div className="max-w-6xl mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-10">
            <div className="flex items-center gap-4">
              <button className="p-2 bg-white/10 rounded-xl hover:bg-white/20 transition-colors">
                <ArrowLeft size={20} />
              </button>
              <div>
                <p className="text-slate-400 text-xs font-medium uppercase tracking-widest">Statistics</p>
                <h1 className="text-2xl font-bold">Electricity Usage</h1>
              </div>
            </div>
            
            <div className="flex bg-white/5 p-1 rounded-xl border border-white/10">
              {['Today', 'Week', 'Month', 'Year', 'Quarter'].map((t) => (
                <button key={t} className={`px-4 py-1.5 rounded-lg text-sm font-bold transition-all ${t === 'Week' ? 'bg-[#facc15] text-slate-900 shadow-lg' : 'text-slate-400 hover:text-white'}`}>
                  {t}
                </button>
              ))}
            </div>
          </div>

          {/* Chart & Summary Cards */}
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
            {/* Main Chart */}
            <div className="lg:col-span-3 h-[350px] relative">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={data}>
                  <defs>
                    <linearGradient id="chartGradient" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="0" vertical={false} stroke="rgba(255,255,255,0.05)" />
                  <XAxis 
                    dataKey="day" 
                    axisLine={false} 
                    tickLine={false} 
                    tick={{fill: 'rgba(255,255,255,0.4)', fontSize: 14, fontWeight: 500}} 
                    dy={20}
                  />
                  <YAxis 
                    axisLine={false} 
                    tickLine={false} 
                    tick={{fill: 'rgba(255,255,255,0.4)', fontSize: 12}} 
                    tickFormatter={(value) => `${value} kW`}
                  />
                  <Tooltip 
                    cursor={{ stroke: '#3b82f6', strokeWidth: 2 }}
                    content={({ active, payload }) => {
                      if (active && payload && payload.length) {
                        return (
                          <div className="bg-white text-slate-900 px-4 py-2 rounded-xl font-bold shadow-xl border-none">
                            {payload[0].value} kW
                          </div>
                        );
                      }
                      return null;
                    }}
                  />
                  <Area 
                    type="monotone" 
                    dataKey="usage" 
                    stroke="#3b82f6" 
                    strokeWidth={4} 
                    fill="url(#chartGradient)" 
                    dot={{ fill: '#3b82f6', strokeWidth: 2, r: 6, stroke: '#fff' }}
                    activeDot={{ r: 8, strokeWidth: 0 }}
                  />
                </AreaChart>
              </ResponsiveContainer>
            </div>

            {/* Side Statistics Cards */}
            <div className="flex flex-col gap-4">
              <div className="bg-white/5 border border-white/10 p-6 rounded-[2rem] flex flex-col justify-between h-full">
                <div>
                  <p className="text-slate-400 text-sm font-medium">This Week</p>
                  <h3 className="text-3xl font-bold mt-1">50 <span className="text-sm font-normal text-slate-500">kW</span></h3>
                </div>
                <div className="flex items-center gap-1 text-emerald-400 text-sm font-bold mt-4">
                  <TrendingUp size={16} /> +7.45%
                </div>
              </div>

              <div className="bg-white/5 border border-white/10 p-6 rounded-[2rem] flex flex-col justify-between h-full">
                <div>
                  <p className="text-slate-400 text-sm font-medium">Total Loss</p>
                  <h3 className="text-3xl font-bold mt-1">30.2 <span className="text-sm font-normal text-slate-500">kW</span></h3>
                </div>
                <div className="flex items-center gap-1 text-red-400 text-sm font-bold mt-4">
                  <TrendingDown size={16} /> -3.35%
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* SECTION 2: ROOMS LIST */}
      <div className="max-w-6xl mx-auto w-full px-8 mt-12">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-bold text-slate-800 flex items-center gap-3">
            Your Rooms <span className="bg-slate-200 text-slate-600 px-2 py-0.5 rounded-md text-xs">4</span>
          </h2>
          <button className="text-blue-600 text-sm font-bold flex items-center gap-1">
            View all <ChevronRight size={16} />
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {roomsData.map((room, idx) => (
            <div key={idx} className="bg-white p-4 rounded-[2.5rem] border border-slate-100 shadow-sm hover:shadow-md transition-all group cursor-pointer">
              <div className="relative h-40 w-full overflow-hidden rounded-[2rem] mb-4">
                <img src={room.img} alt={room.name} className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" />
                <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
              </div>
              <div className="flex justify-between items-end px-2 pb-2">
                <div>
                  <h4 className="font-bold text-slate-800">{room.name}</h4>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="w-2 h-2 rounded-full bg-blue-500"></span>
                    <span className="text-xs text-slate-400 font-medium">{room.devices} devices</span>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-xl font-black text-slate-800">{room.usage} <span className="text-xs font-normal text-slate-400">kW</span></p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

    </div>
  );
};

export default Statistics;
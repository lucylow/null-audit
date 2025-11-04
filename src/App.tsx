import { useState, useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { supabase } from '@/integrations/supabase/client'
import { Session } from '@supabase/supabase-js'
import { Toaster } from 'sonner'
import Auth from './pages/Auth'
import './App.css'

function App() {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Set up auth state listener
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setSession(session);
        setLoading(false);
      }
    );

    // Check for existing session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p>Loading...</p>
      </div>
    );
  }

  return (
    <BrowserRouter>
      <Toaster position="top-center" />
      <Routes>
        <Route path="/auth" element={!session ? <Auth /> : <Navigate to="/" />} />
        <Route path="/" element={
          session ? (
            <div className="min-h-screen bg-gray-50">
              <div className="max-w-7xl mx-auto px-4 py-8">
                <h1 className="text-4xl font-bold text-center mb-8">Arbitra</h1>
                <p className="text-center text-gray-600 mb-8">
                  Decentralized Dispute Resolution Platform - Coming Soon
                </p>
                <div className="text-center">
                  <button
                    onClick={() => supabase.auth.signOut()}
                    className="bg-red-600 text-white px-6 py-2 rounded-lg hover:bg-red-700"
                  >
                    Sign Out
                  </button>
                </div>
              </div>
            </div>
          ) : (
            <Navigate to="/auth" />
          )
        } />
      </Routes>
    </BrowserRouter>
  );
}

export default App;

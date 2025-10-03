import { Menu, X } from 'lucide-react';
import { useState } from 'react';

interface LandingPageProps {
  onNavigateToLogin: () => void;
}

export function LandingPage({ onNavigateToLogin }: LandingPageProps) {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <div className="min-h-screen bg-white">
      <nav className="bg-white shadow-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex items-center justify-between h-20">
            <div className="flex items-center gap-3">
              <div className="bg-blue-900 p-2 rounded">
                <div className="w-12 h-12 bg-white rounded flex items-center justify-center">
                  <span className="text-blue-900 font-bold text-2xl">N</span>
                </div>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">NITTE</h1>
                <h2 className="text-sm text-gray-600">Meenakshi Institute of Technology</h2>
              </div>
            </div>

            <div className="hidden lg:flex items-center gap-1">
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                HOME
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                ADMISSIONS
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                CREDENTIAL VERIFICATION
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                NIRF OVERALL 2025
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                PLACEMENT
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                NIRF INNOVATION 2025
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                E-RESULTS
              </button>
              <button
                onClick={onNavigateToLogin}
                className="px-4 py-2 text-white bg-blue-600 hover:bg-blue-700 rounded transition-colors text-sm font-medium"
              >
                PARENT PORTAL
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                TECH QNA
              </button>
              <button className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                CONTACT US
              </button>
            </div>

            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="lg:hidden p-2 hover:bg-gray-100 rounded"
            >
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>

        {isMenuOpen && (
          <div className="lg:hidden bg-white border-t shadow-lg">
            <div className="max-w-7xl mx-auto px-4 py-4 space-y-2">
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                HOME
              </button>
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                ABOUT US
              </button>
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                PROGRAMS
              </button>
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                RESEARCH
              </button>
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                LIFE@NMIT
              </button>
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                QUICK LINKS
              </button>
              <button className="block w-full text-left px-4 py-3 text-gray-700 hover:bg-gray-100 rounded transition-colors text-sm font-medium">
                DISCOVER NITTE
              </button>
              <button
                onClick={onNavigateToLogin}
                className="block w-full text-left px-4 py-3 text-white bg-blue-600 hover:bg-blue-700 rounded transition-colors text-sm font-medium"
              >
                PARENT PORTAL
              </button>
            </div>
          </div>
        )}
      </nav>

      <div className="relative">
        <div className="h-[600px] bg-gradient-to-br from-blue-900 via-blue-800 to-blue-900 flex items-center justify-center">
          <div className="max-w-7xl mx-auto px-4 text-center text-white">
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              Welcome to NMIT
            </h1>
            <p className="text-xl md:text-2xl mb-8 text-blue-100 max-w-3xl mx-auto">
              Nitte Meenakshi Institute of Technology - Shaping the Future of Engineering Education
            </p>
            <button
              onClick={onNavigateToLogin}
              className="bg-white text-blue-900 px-8 py-4 rounded-lg text-lg font-semibold hover:bg-blue-50 transition-colors shadow-lg"
            >
              Access Parent Portal
            </button>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-16">
        <div className="grid md:grid-cols-3 gap-8">
          <div className="bg-white p-8 rounded-lg shadow-lg border border-gray-200">
            <h3 className="text-2xl font-bold mb-4 text-gray-900">About Us</h3>
            <p className="text-gray-600 leading-relaxed">
              Nitte Meenakshi Institute of Technology is an autonomous engineering college in Bangalore, Karnataka, India affiliated to the Visvesvaraya Technological University, Belagavi.
            </p>
          </div>

          <div className="bg-white p-8 rounded-lg shadow-lg border border-gray-200">
            <h3 className="text-2xl font-bold mb-4 text-gray-900">Programs</h3>
            <p className="text-gray-600 leading-relaxed">
              We offer undergraduate and postgraduate programs in various disciplines including Computer Science, Electronics, Mechanical, and more.
            </p>
          </div>

          <div className="bg-white p-8 rounded-lg shadow-lg border border-gray-200">
            <h3 className="text-2xl font-bold mb-4 text-gray-900">Research</h3>
            <p className="text-gray-600 leading-relaxed">
              Our research facilities and programs are designed to foster innovation and contribute to technological advancement in various fields.
            </p>
          </div>
        </div>
      </div>

      <div className="bg-gray-100 py-16">
        <div className="max-w-7xl mx-auto px-4">
          <h2 className="text-4xl font-bold text-center mb-12 text-gray-900">Quick Links</h2>
          <div className="grid md:grid-cols-4 gap-6">
            <button className="bg-white p-6 rounded-lg shadow hover:shadow-lg transition-shadow text-center">
              <h3 className="font-semibold text-lg text-gray-900">Admissions</h3>
            </button>
            <button className="bg-white p-6 rounded-lg shadow hover:shadow-lg transition-shadow text-center">
              <h3 className="font-semibold text-lg text-gray-900">Placement</h3>
            </button>
            <button className="bg-white p-6 rounded-lg shadow hover:shadow-lg transition-shadow text-center">
              <h3 className="font-semibold text-lg text-gray-900">E-Results</h3>
            </button>
            <button
              onClick={onNavigateToLogin}
              className="bg-blue-600 p-6 rounded-lg shadow hover:shadow-lg transition-shadow text-center"
            >
              <h3 className="font-semibold text-lg text-white">Parent Portal</h3>
            </button>
          </div>
        </div>
      </div>

      <footer className="bg-gray-900 text-white py-8">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid md:grid-cols-4 gap-8 mb-8">
            <div>
              <h3 className="text-lg font-bold mb-4">About NMIT</h3>
              <p className="text-gray-400 text-sm">
                An autonomous engineering college affiliated to VTU, committed to excellence in education.
              </p>
            </div>
            <div>
              <h3 className="text-lg font-bold mb-4">Quick Links</h3>
              <ul className="space-y-2 text-sm text-gray-400">
                <li><a href="#" className="hover:text-white">About Us</a></li>
                <li><a href="#" className="hover:text-white">Programs</a></li>
                <li><a href="#" className="hover:text-white">Research</a></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-bold mb-4">Contact</h3>
              <p className="text-gray-400 text-sm">
                Yelahanka, Bangalore<br />
                Karnataka, India<br />
                Phone: +91-80-XXXXXXXX
              </p>
            </div>
            <div>
              <h3 className="text-lg font-bold mb-4">Connect</h3>
              <p className="text-gray-400 text-sm">
                Follow us on social media
              </p>
            </div>
          </div>
          <div className="border-t border-gray-800 pt-6 flex items-center justify-between">
            <p className="text-sm text-gray-400">Copyright © Powered By Contineo</p>
            <div className="flex gap-6 text-sm text-gray-400">
              <a href="#" className="hover:text-white">Terms of Service</a>
              <a href="#" className="hover:text-white">Privacy Policy</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}

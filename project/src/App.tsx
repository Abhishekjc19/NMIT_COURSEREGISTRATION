import { useState, useEffect } from 'react';
import { User, LogOut, Loader2 } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, RadialBarChart, RadialBar } from 'recharts';
import { LandingPage } from './components/LandingPage';

const API_BASE_URL = 'http://localhost:8090';

interface Student {
  name: string;
  usn: string;
  profilePicture: string;
  department: string;
  semester: number;
  rollNo: number;
  section: string;
}

interface CIEData {
  subject: string;
  marks: number;
}

interface AttendanceData {
  subject: string;
  percentage: number;
  fill: string;
}

interface Course {
  courseCode: string;
  subjectName: string;
  credits: number;
  status: string;
}

interface DashboardData {
  cieData: CIEData[];
  attendanceData: AttendanceData[];
}

interface NoticeItem {
  id: number;
  message: string;
}

type AppPage = 'LANDING' | 'LOGIN' | 'DASHBOARD' | 'REGISTRATION';

function App() {
  const [currentPage, setCurrentPage] = useState<AppPage>('LANDING');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [token, setToken] = useState<string | null>(null);

  const [usn, setUsn] = useState('');
  const [dobDay, setDobDay] = useState('');
  const [dobMonth, setDobMonth] = useState('');
  const [dobYear, setDobYear] = useState('');

  const [student, setStudent] = useState<Student | null>(null);
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [courses, setCourses] = useState<Course[]>([]);
  const [notices, setNotices] = useState<NoticeItem[]>([]);

  useEffect(() => {
    if (currentPage === 'LOGIN') {
      fetchNotices();
    }
  }, [currentPage]);

  const fetchNotices = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/api/notices`);
      if (response.ok) {
        const data = await response.json();
        setNotices(data);
      }
    } catch (err) {
      console.error('Failed to fetch notices:', err);
    }
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const response = await fetch(`${API_BASE_URL}/auth/student-login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          usn: usn,
          dob: `${dobDay.padStart(2, '0')}/${dobMonth.padStart(2, '0')}/${dobYear}`,
        }),
      });

      if (!response.ok) {
        throw new Error('Invalid credentials');
      }

      const data = await response.json();
      const accessToken: string | undefined = data?.accessToken;
      if (!accessToken) {
        throw new Error('Missing token in response');
      }
      localStorage.setItem('jwt', accessToken);
      setToken(accessToken);

      await fetchStudentData(accessToken);
      await fetchDashboardData(accessToken);
      await fetchCourses(accessToken);
      setCurrentPage('DASHBOARD');
    } catch (err) {
      setError('Login failed. Please check your credentials.');
      console.error('Login error:', err);
    } finally {
      setLoading(false);
    }
  };

  const fetchStudentData = async (jwt?: string) => {
    try {
      const response = await fetch(`${API_BASE_URL}/students/my-profile`, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${jwt || token || localStorage.getItem('jwt') || ''}`,
        },
      });

      if (response.ok) {
        const data = await response.json();
        // Some controllers wrap payloads; support both direct and wrapped response
        setStudent(data?.data || data);
      }
    } catch (err) {
      console.error('Failed to fetch student data:', err);
    }
  };

  const fetchDashboardData = async (jwt?: string) => {
    try {
      const response = await fetch(`${API_BASE_URL}/students/dashboard`, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${jwt || token || localStorage.getItem('jwt') || ''}`,
        },
      });

      if (response.ok) {
        const data = await response.json();
        setDashboardData(data);
      }
    } catch (err) {
      console.error('Failed to fetch dashboard data:', err);
    }
  };

  const fetchCourses = async (jwt?: string) => {
    try {
      const response = await fetch(`${API_BASE_URL}/students/courses`, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${jwt || token || localStorage.getItem('jwt') || ''}`,
        },
      });

      if (response.ok) {
        const data = await response.json();
        setCourses(data);
      }
    } catch (err) {
      console.error('Failed to fetch courses:', err);
    }
  };

  const handleLogout = () => {
    setCurrentPage('LANDING');
    setStudent(null);
    setDashboardData(null);
    setCourses([]);
    setUsn('');
    setDobDay('');
    setDobMonth('');
    setDobYear('');
    setError('');
    setToken(null);
    localStorage.removeItem('jwt');
  };

  if (currentPage === 'LANDING') {
    return <LandingPage onNavigateToLogin={() => setCurrentPage('LOGIN')} />;
  }

  if (currentPage === 'LOGIN') {
    return (
      <div className="min-h-screen bg-gray-100">
        <div className="grid lg:grid-cols-2 min-h-screen">
          <div className="bg-gradient-to-br from-blue-900 via-blue-800 to-blue-900 p-8 lg:p-16 flex flex-col justify-between text-white">
            <div>
              <div className="flex items-center gap-3 mb-8">
                <div className="bg-white p-2 rounded">
                  <div className="w-12 h-12 bg-blue-900 rounded flex items-center justify-center">
                    <span className="text-white font-bold text-xl">N</span>
                  </div>
                </div>
                <div>
                  <h1 className="text-2xl font-bold">NITTE MEENAKSHI</h1>
                  <h2 className="text-xl">INSTITUTE OF TECHNOLOGY</h2>
                </div>
              </div>

              <div className="mb-8">
                <h3 className="text-3xl font-bold mb-4">Welcome to NMIT</h3>
                <p className="text-blue-100 text-lg leading-relaxed">
                  Nitte Meenakshi Institute of Technology is an autonomous engineering college in Bangalore, Karnataka, India affiliated to the Visvesvaraya Technological University, Belagavi.
                </p>
              </div>
            </div>

            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6">
              <h4 className="text-xl font-semibold mb-4">Notice Board</h4>
              <div className="bg-white/5 rounded p-4 max-h-40 overflow-y-auto">
                {notices.length > 0 ? (
                  notices.map((notice) => (
                    <div key={notice.id} className="flex items-start gap-2 mb-2">
                      <span className="text-blue-300 mt-1">ℹ</span>
                      <p className="text-blue-50">{notice.message}</p>
                    </div>
                  ))
                ) : (
                  <p className="text-blue-200">Welcome to the preview of the new mobile friendly parent portal</p>
                )}
              </div>
            </div>
          </div>

          <div className="bg-gray-50 flex items-center justify-center p-8">
            <div className="bg-blue-800 rounded-lg shadow-2xl p-8 w-full max-w-md">
              <h3 className="text-2xl font-bold text-white mb-6">Login to Your Account</h3>

              {error && (
                <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                  {error}
                </div>
              )}

              <form onSubmit={handleLogin}>
                <div className="mb-4">
                  <label className="block text-white text-sm font-semibold mb-2">
                    Username
                  </label>
                  <div className="relative">
                    <input
                      type="text"
                      placeholder="USN"
                      value={usn}
                      onChange={(e) => setUsn(e.target.value.toUpperCase())}
                      className="w-full px-4 py-3 rounded bg-white border-none focus:ring-2 focus:ring-blue-300 outline-none"
                      required
                    />
                  </div>
                </div>

                <div className="mb-4">
                  <label className="block text-white text-sm font-semibold mb-2">
                    Date of Birth
                  </label>
                  <div className="grid grid-cols-3 gap-2">
                    <select
                      value={dobDay}
                      onChange={(e) => setDobDay(e.target.value)}
                      className="px-3 py-3 rounded bg-white border-none focus:ring-2 focus:ring-blue-300 outline-none"
                      required
                    >
                      <option value="">Day</option>
                      {Array.from({ length: 31 }, (_, i) => i + 1).map((day) => (
                        <option key={day} value={day}>
                          {day}
                        </option>
                      ))}
                    </select>
                    <select
                      value={dobMonth}
                      onChange={(e) => setDobMonth(e.target.value)}
                      className="px-3 py-3 rounded bg-white border-none focus:ring-2 focus:ring-blue-300 outline-none"
                      required
                    >
                      <option value="">Month</option>
                      {Array.from({ length: 12 }, (_, i) => i + 1).map((month) => (
                        <option key={month} value={month}>
                          {month}
                        </option>
                      ))}
                    </select>
                    <select
                      value={dobYear}
                      onChange={(e) => setDobYear(e.target.value)}
                      className="px-3 py-3 rounded bg-white border-none focus:ring-2 focus:ring-blue-300 outline-none"
                      required
                    >
                      <option value="">Year</option>
                      {Array.from({ length: 30 }, (_, i) => 2010 - i).map((year) => (
                        <option key={year} value={year}>
                          {year}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>

                <div className="flex items-center justify-between mb-6">
                  <a href="#" className="text-white text-sm hover:underline">
                    Forgot Password?
                  </a>
                </div>

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-white text-blue-800 font-bold py-3 rounded hover:bg-blue-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                >
                  {loading ? (
                    <>
                      <Loader2 className="w-5 h-5 animate-spin" />
                      Logging in...
                    </>
                  ) : (
                    'LOGIN'
                  )}
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }

  const totalCredits = courses.reduce((sum, course) => sum + course.credits, 0);
  const attendancePercentage = dashboardData?.attendanceData.length
    ? Math.round(dashboardData.attendanceData.reduce((sum, item) => sum + item.percentage, 0) / dashboardData.attendanceData.length)
    : 0;

  return (
    <div className="min-h-screen bg-gray-100">
      <nav className="bg-gradient-to-r from-blue-900 to-blue-800 text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex items-center justify-between h-20">
            <div className="flex items-center gap-3">
              <div className="bg-white p-1.5 rounded">
                <div className="w-10 h-10 bg-blue-900 rounded flex items-center justify-center">
                  <span className="text-white font-bold text-lg">N</span>
                </div>
              </div>
              <div>
                <h1 className="text-lg font-bold">NITTE MEENAKSHI</h1>
                <h2 className="text-sm">INSTITUTE OF TECHNOLOGY</h2>
              </div>
            </div>

            <div className="flex items-center gap-6">
              <button
                onClick={() => setCurrentPage('DASHBOARD')}
                className={`px-4 py-2 rounded transition-colors ${
                  currentPage === 'DASHBOARD' ? 'bg-white/20' : 'hover:bg-white/10'
                }`}
              >
                HOME
              </button>
              <button
                onClick={() => setCurrentPage('REGISTRATION')}
                className={`px-4 py-2 rounded transition-colors ${
                  currentPage === 'REGISTRATION' ? 'bg-white/20' : 'hover:bg-white/10'
                }`}
              >
                COURSE REGISTRATION
              </button>
              <button
                onClick={handleLogout}
                className="flex items-center gap-2 px-4 py-2 bg-red-600 hover:bg-red-700 rounded transition-colors"
              >
                <LogOut className="w-4 h-4" />
                LOGOUT
              </button>
            </div>
          </div>
        </div>
      </nav>

      <div className="bg-gradient-to-r from-blue-800 to-blue-700 text-white">
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="flex items-center gap-6">
            <div className="relative">
              {student?.profilePicture ? (
                <img
                  src={student.profilePicture}
                  alt={student.name}
                  className="w-24 h-24 rounded-full border-4 border-white shadow-lg object-cover"
                />
              ) : (
                <div className="w-24 h-24 rounded-full border-4 border-white shadow-lg bg-blue-900 flex items-center justify-center">
                  <User className="w-12 h-12" />
                </div>
              )}
            </div>
            <div className="flex-1">
              <h2 className="text-3xl font-bold mb-1">{student?.name || 'Loading...'}</h2>
              <div className="flex items-center gap-6 text-blue-100">
                <span className="text-lg">{student?.usn || ''}</span>
                <span>B.E-{student?.department?.substring(0, 2) || 'AM'}, SEM {student?.semester || '05'}, SEC {student?.section || 'A'}</span>
              </div>
            </div>
            <div className="text-right">
              <div className="text-2xl font-bold">{student?.usn || ''}</div>
              <div className="text-sm text-blue-100">Feedback manual</div>
            </div>
          </div>
          <div className="mt-4 text-sm text-blue-100">
            Last Updated On: {new Date().toLocaleDateString('en-GB')}
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-8">
        {currentPage === 'DASHBOARD' ? (
          <div className="space-y-6">
            <div className="grid md:grid-cols-2 gap-6">
              <div className="bg-white rounded-lg shadow-lg p-6">
                <h3 className="text-xl font-bold mb-4 text-gray-800">CIE</h3>
                {dashboardData?.cieData && dashboardData.cieData.length > 0 ? (
                  <ResponsiveContainer width="100%" height={300}>
                    <BarChart data={dashboardData.cieData}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="subject" />
                      <YAxis />
                      <Tooltip />
                      <Legend />
                      <Bar dataKey="marks" fill="#1e40af" />
                    </BarChart>
                  </ResponsiveContainer>
                ) : (
                  <div className="h-64 flex items-center justify-center text-gray-400">
                    <Loader2 className="w-8 h-8 animate-spin" />
                  </div>
                )}
              </div>

              <div className="bg-white rounded-lg shadow-lg p-6">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-xl font-bold text-gray-800">Attendance</h3>
                  {attendancePercentage < 80 && (
                    <span className="bg-red-600 text-white text-xs font-bold px-3 py-1 rounded">
                      {attendancePercentage} BELOW 80%
                    </span>
                  )}
                </div>
                {dashboardData?.attendanceData && dashboardData.attendanceData.length > 0 ? (
                  <ResponsiveContainer width="100%" height={300}>
                    <RadialBarChart
                      cx="50%"
                      cy="50%"
                      innerRadius="20%"
                      outerRadius="90%"
                      data={dashboardData.attendanceData}
                      startAngle={180}
                      endAngle={0}
                    >
                      <RadialBar
                        background
                        dataKey="percentage"
                      />
                      <Legend
                        iconSize={10}
                        layout="vertical"
                        verticalAlign="bottom"
                        align="center"
                      />
                      <Tooltip />
                    </RadialBarChart>
                  </ResponsiveContainer>
                ) : (
                  <div className="h-64 flex items-center justify-center text-gray-400">
                    <Loader2 className="w-8 h-8 animate-spin" />
                  </div>
                )}
              </div>
            </div>

            <div className="bg-white rounded-lg shadow-lg p-6">
              <h3 className="text-xl font-bold mb-4 text-gray-800">Credits</h3>
              <div className="text-center py-8 text-gray-500">
                <p className="text-lg">----------Coming Soon----------</p>
              </div>
            </div>
          </div>
        ) : (
          <div className="bg-white rounded-lg shadow-lg">
            <div className="border-l-4 border-red-600 p-6">
              <h3 className="text-xl font-bold text-gray-800">View Course Registration</h3>
            </div>

            <div className="p-6 border-b">
              <div className="flex items-start gap-6">
                <div>
                  {student?.profilePicture ? (
                    <img
                      src={student.profilePicture}
                      alt={student.name}
                      className="w-20 h-20 rounded-full object-cover"
                    />
                  ) : (
                    <div className="w-20 h-20 rounded-full bg-blue-800 flex items-center justify-center">
                      <User className="w-10 h-10 text-white" />
                    </div>
                  )}
                </div>
                <div className="flex-1 grid md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-gray-600 text-sm">Student Name: <span className="text-gray-900 font-semibold">{student?.name || ''}</span></p>
                    <p className="text-gray-600 text-sm mt-2">Department: <span className="text-gray-900 font-semibold">{student?.department || ''}</span></p>
                    <p className="text-gray-600 text-sm mt-2">Total Credits: <span className="text-gray-900 font-semibold">{totalCredits.toFixed(2)}</span></p>
                  </div>
                  <div>
                    <p className="text-gray-600 text-sm">USN: <span className="text-gray-900 font-semibold">{student?.usn || ''}</span></p>
                    <p className="text-gray-600 text-sm mt-2">Total Credits: <span className="text-gray-900 font-semibold">{totalCredits.toFixed(2)}</span></p>
                    <div className="mt-2">
                      <button className="bg-red-600 text-white px-4 py-1 rounded text-sm hover:bg-red-700 transition-colors">
                        ACKNOWLEDGEMENT
                      </button>
                    </div>
                  </div>
                  <div>
                    <p className="text-gray-600 text-sm">Roll No.: <span className="text-gray-900 font-semibold">{student?.rollNo || 0}</span></p>
                    <p className="text-gray-600 text-sm mt-2">Semester {student?.semester || 5}</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="p-6">
              <div className="mb-4">
                <h4 className="text-lg font-bold text-gray-800">
                  Semester {student?.semester || 5}
                  <span className="ml-4 bg-green-600 text-white px-4 py-1 rounded text-sm">
                    SEMESTER WISE CREDITS :{totalCredits.toFixed(2)}
                  </span>
                </h4>
              </div>

              <div className="mb-4">
                <h5 className="font-semibold text-gray-700">Core Courses</h5>
              </div>

              {courses.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead>
                      <tr className="border-b-2 border-gray-300">
                        <th className="text-left py-3 px-4 font-semibold text-gray-700">COURSE CODE</th>
                        <th className="text-left py-3 px-4 font-semibold text-gray-700">SUBJECT NAME</th>
                        <th className="text-center py-3 px-4 font-semibold text-gray-700">CREDITS</th>
                        <th className="text-center py-3 px-4 font-semibold text-gray-700">STATUS</th>
                      </tr>
                    </thead>
                    <tbody>
                      {courses.map((course, index) => (
                        <tr key={index} className="border-b hover:bg-gray-50">
                          <td className="py-3 px-4 font-semibold">{course.courseCode}</td>
                          <td className="py-3 px-4">{course.subjectName}</td>
                          <td className="py-3 px-4 text-center">{course.credits.toFixed(2)}</td>
                          <td className="py-3 px-4 text-center">
                            <span className="text-green-600 font-semibold">{course.status}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <div className="text-center py-8 text-gray-400">
                  <Loader2 className="w-8 h-8 animate-spin mx-auto" />
                  <p className="mt-2">Loading courses...</p>
                </div>
              )}
            </div>
          </div>
        )}
      </div>

      <footer className="bg-gray-800 text-white py-6 mt-12">
        <div className="max-w-7xl mx-auto px-4 flex items-center justify-between">
          <p className="text-sm">Copyright © Powered By Contineo</p>
          <div className="flex gap-6 text-sm">
            <a href="#" className="hover:text-blue-300">Terms of Service</a>
            <a href="#" className="hover:text-blue-300">Privacy Policy</a>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;